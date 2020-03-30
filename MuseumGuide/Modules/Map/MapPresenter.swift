//
//  MapPresenter.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Combine
import Mapbox

class MapPresenter: NSObject, MapEventHandler {
    weak var view: MapViewController!
    var router: MapRouter
    
    let tableViewWorker: TableViewWorker
    let pullingViewWorker: PullingViewWorker
    
    private let networkManager: NetworkManager
    private var subscriptions = Set<AnyCancellable>()
    private var features: [MGLPointFeature]?
    
    private var mapView: MGLMapView { view.mapView }
    
    enum Map {
        static let layerIdentifiers: Set = ["museums-symbols"]
    }
    
    private var mapFinishedAnimating = false {
        didSet {
            if oldValue == false {
                guard let features = features, let userCoordinates = view.mapView.userLocation?.coordinate else { return }
                self.tryProcessAsClosest(possibleFeatures: features, touchLocation: CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude))
            }
        }
    }
    
    init(view: MapViewController, router: MapRouter, networkManager: NetworkManager, tableViewWorker: TableViewWorker, pullingViewWorker: PullingViewWorker) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
        self.tableViewWorker = tableViewWorker
        self.pullingViewWorker = pullingViewWorker
    }

    func handleMapTap(sender: UITapGestureRecognizer) {
        log(.debug, "Handling map tap.")
        guard sender.state == .ended else { return }
        let point = sender.location(in: sender.view)
        tryProcessAsExactPoint(point: point, sender: sender)
            .flatMap { isFound -> AnyPublisher<Bool, Never> in
                let touchCoordinate = self.mapView.convert(point, toCoordinateFrom: sender.view!)
                let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
                let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
                let possibleFeatures = self.mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(Map.layerIdentifiers)).filter { $0 is MGLPointFeature }
                
                return isFound ?
                    Just(true).eraseToAnyPublisher() :
                    self.tryProcessAsClosest(possibleFeatures: possibleFeatures, touchLocation: touchLocation)
        }.sink { isFound in
            if !isFound {
                self.hideInfo()
                self.view.mapView.deselectAnnotation(self.mapView.selectedAnnotations.first, animated: true)
            }
        }
        .store(in: &subscriptions)
    }
    
    func deselectAnnotation() {
        guard let selectedAnnotation = view.mapView.selectedAnnotations.first else {
            return
        }
        view.mapView.deselectAnnotation(selectedAnnotation, animated: true)
    }
}

//MARK: - MGLMapViewDelegate

extension MapPresenter: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return UserLocationAnnotationView()
        }
        return MGLAnnotationView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    }
    
    // Tap the user location annotation to toggle heading tracking mode.
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        log(.debug, "didSelect annotation")
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            if mapView.userTrackingMode != .followWithHeading {
                mapView.userTrackingMode = .followWithHeading
            } else {
                mapView.resetNorth()
            }
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    func mapViewDidBecomeIdle(_ mapView: MGLMapView) {
        mapFinishedAnimating = true
        log(.debug, "Did become idle.")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        networkManager.getMuseums()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.log(.debug, "Error -> \(error.errorDescription ?? .emptyLine)")
                }
            }, receiveValue: { museums in
                let features = museums.map { museum -> MGLPointFeature in
                    let feature = MGLPointFeature()
                    feature.coordinate = CLLocationCoordinate2D(latitude: museum.lat, longitude: museum.lon)
                    feature.title = museum.name
                    feature.attributes = [
                        "description": museum.description,
                        "name": museum.name,
                        "types": museum.types
                    ]
                    return feature
                }
                self.features = features
                self.addItemsToMap(features: features)
            }).store(in: &subscriptions)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
        log(.debug, "didDeselect annotation")
        mapView.removeAnnotations([annotation])
        hideInfo()
    }
    
}

//MARK: - Private methods

private extension MapPresenter {
    
    private func addItemsToMap(features: [MGLPointFeature]) {
        guard let style = view.mapView.style else { return }
        let source = MGLShapeSource(identifier: "museums", features: features, options: nil)
        style.setImage(UIImage(named: "pin_icon_filled")!, forName: "museum")
        style.addSource(source)
        style.addLayer(makeMuseumSymbolsLayer(with: source))
    }
    
    private func makeMuseumSymbolsLayer(with source: MGLShapeSource) -> MGLSymbolStyleLayer {
        let symbols = MGLSymbolStyleLayer(identifier: "museums-symbols", source: source)
        symbols.iconImageName = NSExpression(forConstantValue: "museum")
        symbols.iconColor = NSExpression(forConstantValue: UIColor.black)
        symbols.iconScale = NSExpression(forConstantValue: 0.4)
        symbols.iconHaloColor = NSExpression(forConstantValue: UIColor.white.withAlphaComponent(0.5))
        symbols.iconHaloWidth = NSExpression(forConstantValue: 1)
        symbols.iconOpacity = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                           [5.9: 0, 6: 1])
        
        //        symbols.text = NSExpression(forKeyPath: "name")
        symbols.textColor = symbols.iconColor
        symbols.textFontSize = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                            [10: 10, 16: 16])
        symbols.textTranslation = NSExpression(forConstantValue: NSValue(cgVector: CGVector(dx: 10, dy: 0)))
        symbols.textOpacity = symbols.iconOpacity
        symbols.textHaloColor = symbols.iconHaloColor
        symbols.textHaloWidth = symbols.iconHaloWidth
        symbols.textJustification = NSExpression(forConstantValue: NSValue(mglTextJustification: .left))
        symbols.textAnchor = NSExpression(forConstantValue: NSValue(mglTextAnchor: .left))
        symbols.iconAnchor = NSExpression(forConstantValue: NSValue(mglIconAnchor: .bottom))
        return symbols
    }
    
    private func tryProcessAsExactPoint(point: CGPoint, sender: UITapGestureRecognizer) -> AnyPublisher<Bool, Never> {
        return Future { promise in
            let possibleFeature = self.view.mapView.visibleFeatures(at: point, styleLayerIdentifiers: Map.layerIdentifiers)
                .compactMap { $0 as? MGLPointFeature }
                .first
            guard let feature = possibleFeature else {
                promise(.success(false))
                return
            }
            self.showCallout(feature: feature)
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
    
    @discardableResult
    private func tryProcessAsClosest(possibleFeatures: [MGLFeature], touchLocation: CLLocation) -> AnyPublisher<Bool, Never> {
        return Future { promise in
            let possibleFeature = possibleFeatures
                .sorted(by: { CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: touchLocation)
                })
                .compactMap { $0 as? MGLPointFeature }
                .first
                
            guard let feature = possibleFeature else {
                promise(.success(false))
                return
            }
            self.showCallout(feature: feature)
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
    
    private func showCallout(feature: MGLPointFeature) {
        let point = MGLPointFeature()
        point.coordinate = feature.coordinate
        tableViewWorker.updateDataSource(with: makeData(from: feature))
        updateHeaderView(with: feature.attributes["types"] as! [String])
        view.mapView.selectAnnotation(point, animated: true, completionHandler: nil)
        showInfo()

    }
    
    private func makeData(from feature: MGLPointFeature) -> [CellModel] {
        let title = feature.attributes["name"] as! String
        let description = feature.attributes["description"] as! String
        return [
            .info(MuseumCell.Info(title: title, subtitle: description)),
            .contacts(ContactsCell.Info(address: "Александровский парк, 7 м. Горьковская, Санкт-Петербург", phone: "7-999-231-88-07")) ]
    }
    
    private func updateHeaderView(with data: [String]) {
        let info = MuseumHeaderView.Info(types: data)
        view.updateHeader(with: info)
    }
    
    private func showInfo() {
        view.showInfo()
    }
    
    private func hideInfo() {
        view.hideInfo()
    }
}

