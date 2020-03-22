//
//  ContainerPresenter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

class ContainerPresenter: ContainerEventHandler {
    weak var view: ContainerViewBehavior!
    var router: ContainerRouter
    private var subscriptions = Set<AnyCancellable>()
    private let store: Store<LocationEffectHandler.S, LocationError>
    
    init(view: ContainerViewBehavior, router: ContainerRouter) {
        self.view = view
        self.router = router
    }
    
    func didLoad() {
        let service = LocationService()
        let events = LocationEvents()
        let effects = LocationEffects(locationService: service)
        let store = Store<LocationEffectHandler.S, LocationError> (effectHandler: effects, eventSource: events, initialState: .idle)
        store.statePublisher.sink { (state) in
            print(state)
        }.store(in: &subscriptions)
        store.dispatch(event: .fetchLocation)
    }
    
    func handleTap() {
        //openMap()
    }
}
