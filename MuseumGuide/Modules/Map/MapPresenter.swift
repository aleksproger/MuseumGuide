//
//  MapPresenter.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import Mapbox

class MapPresenter: NSObject, MapEventHandler {
    weak var view: MapViewController!
    var router: MapRouter
    private var cellInfos: [CellModel] = MuseumCell.makeDefaultInfos() + ContactsCell.makeDefaultInfos()
//    private var cellInfos = MuseumCell.makeDefaultInfos()
//    private var contactsInfos = ContactsCell.makeDefaultInfos()
    private let networkManager: NetworkManager
    private var subscriptions = Set<AnyCancellable>()
    private var features: [MGLPointFeature]?
    private var mapFinishedAnimating = false {
        didSet {
            if oldValue == false {
                guard let features = features, let userCoordinates = view.mapView.userLocation?.coordinate else { return }
                self.tryProcessClosestFeature(possibleFeatures: features, touchLocation: CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude))
            }
        }
    }

    
    init(view: MapViewController, router: MapRouter, networkManager: NetworkManager) {
        self.view = view
        self.router = router
        self.networkManager = networkManager
    }
    
    func handleMapTap(sender: UITapGestureRecognizer) {
        log(.debug, "Handling map tap.")
        guard sender.state == .ended else { return }
        
        // Limit feature selection to just the following layer identifiers.
        let layerIdentifiers: Set = ["museums-symbols"]
        let point = sender.location(in: sender.view!)
        
        // Try matching the exact point first.
        if tryProcessAsExactPoint(point: point, sender: sender, layerIdentifiers: layerIdentifiers) { return }
        
        // Otherwise, get all features within a rect the size of a touch (44x44).
        let touchCoordinate = view.mapView.convert(point, toCoordinateFrom: sender.view!)
        let touchLocation = CLLocation(latitude: touchCoordinate.latitude, longitude: touchCoordinate.longitude)
        let touchRect = CGRect(origin: point, size: .zero).insetBy(dx: -22.0, dy: -22.0)
        let possibleFeatures = view.mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: Set(layerIdentifiers)).filter { $0 is MGLPointFeature }
        
        // Select the closest feature to the touch center.
        if tryProcessClosestFeature(possibleFeatures: possibleFeatures, touchLocation: touchLocation) { return }
        
        // If no features were found, deselect the selected annotation, if any.
        view.mapView.deselectAnnotation(view.mapView.selectedAnnotations.first, animated: true)
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
                        "name": museum.name
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
    
    private func tryProcessAsExactPoint(point: CGPoint, sender: UITapGestureRecognizer, layerIdentifiers: Set<String>) -> Bool {
        for feature in view.mapView.visibleFeatures(at: point, styleLayerIdentifiers: layerIdentifiers)
            where feature is MGLPointFeature {
                guard let selectedFeature = feature as? MGLPointFeature else {
                    fatalError("Failed to cast selected feature as MGLPointFeature")
                }
                showCallout(feature: selectedFeature)
                return true
        }
        return false
    }
    
    private func tryProcessClosestFeature(possibleFeatures: [MGLFeature], touchLocation: CLLocation) -> Bool {
        let closestFeatures = possibleFeatures.sorted(by: {
            return CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude).distance(from: touchLocation) < CLLocation(latitude: $1.coordinate.latitude, longitude: $1.coordinate.longitude).distance(from: touchLocation)
        })
        if let feature = closestFeatures.first {
            guard let closestFeature = feature as? MGLPointFeature else {
                fatalError("Failed to cast selected feature as MGLPointFeature")
            }
            showCallout(feature: closestFeature)
            return true
        }
        return false
    }
    
    private func showCallout(feature: MGLPointFeature) {
        let point = MGLPointFeature()
        point.coordinate = feature.coordinate
        let title = feature.attributes["name"] as! String
        let description = feature.attributes["description"] as! String
        cellInfos = [CellModel.info(MuseumCell.Info(title: title, subtitle: description))]
        cellInfos.append(CellModel.contacts(ContactsCell.Info(address: "Александровский парк, 7 м. Горьковская, Санкт-Петербург", phone: "7-999-231-88-07")))
        view.mapView.selectAnnotation(point, animated: true, completionHandler: nil)
        showInfo(title: "Музей")

    }
    
    private func showInfo(title: String) {
        let info = MuseumHeaderView.Info(title: title)
        view.showInfo(info: info)
    }
    
    private func hideInfo() {
        view.hideInfo()
    }
}


extension MapPresenter: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellInfos[indexPath.row]
        switch cellModel {
        case .contacts(let contacts):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(ContactsCell.self)", for: indexPath) as! ContactsCell
            cell.update(with: contacts)
            return cell

        case .info(let museum):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(MuseumCell.self)", for: indexPath) as! MuseumCell
            cell.update(with: museum)
            return cell

        }
//        if let cell = cell as? MuseumCell {
//            cell.update(with: cellInfos[indexPath.row])
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return MuseumCell.Layout.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum CellModel {
    case info(MuseumCell.Info)
    case contacts(ContactsCell.Info)
}
