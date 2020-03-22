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

class MapPresenter: MapEventHandler {
    weak var view: MapViewController!
    var router: MapRouter
    private var subscriptions = Set<AnyCancellable>()
//    private let statefulView: AnyStatefulView<MapViewState>
    private let effects: LocationEffects
    private let events: LocationEvents
    private lazy var store = Store<LocationEffects.S, LocationError> (effectHandler: effects, eventSource: events, initialState: .idle)
    
    init(view: MapViewController, router: MapRouter, events: LocationEvents, effects: LocationEffects) {
        self.view = view
        self.router = router
        self.events = events
        self.effects = effects
    }
    
    func didLoad() {
        store.statePublisher.sink { (state) in
            self.view.render(state: MapViewState(domainState: state))
        }.store(in: &subscriptions)
        store.dispatch(event: .fetchLocation)
    }
    
    func setLocation(location: CLLocation) {
        
    }
}

enum MapViewState: ViewState {
    case fetching
    case fetched(CLLocation)
    case error(Error?)
    
    init(domainState: LocationState) {
        switch domainState {
        case .idle, .loading:
            self = .fetching
        case .loaded(let location):
            self = .fetched(location)
        case .error:
            self =  .error(nil)
        }
    }
}
