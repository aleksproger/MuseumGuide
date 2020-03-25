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
    private var subscriptions = Set<AnyCancellable>()
    //    private let statefulView: AnyStatefulView<MapViewState>
    private let effects: MapEffects
    private let events: MapEvents
//    private lazy var store = Store<MapEffects.S, MapError> (effectHandler: effects, eventSource: events, initialState: .idle)
//
    init(view: MapViewController, router: MapRouter, events: MapEvents, effects: MapEffects) {
        self.view = view
        self.router = router
        self.events = events
        self.effects = effects
    }
    
    func didLoad() {


//        store.statePublisher.sink { (state) in
//            self.view.render(state: MapViewState(domainState: state))
//        }.store(in: &subscriptions)
        //store.dispatch(event: .fetchLocation)
    }
    
    func setLocation(location: CLLocation) {
        
    }
}

extension MapPresenter: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // Substitute our custom view for the user location annotation. This custom view is defined below.
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return CustomUserLocationAnnotationView()
        }
        return nil
    }
    
    // Optional: tap the user location annotation to toggle heading tracking mode.
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        if mapView.userTrackingMode != .followWithHeading {
            mapView.userTrackingMode = .followWithHeading
        } else {
            mapView.resetNorth()
        }
        
        // We're borrowing this method as a gesture recognizer, so reset selection state.
        mapView.deselectAnnotation(annotation, animated: false)
    }
}

