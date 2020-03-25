//
//  MapEvents.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class MapEvents: EventSource {
    typealias S = MapState
    //private let store: Store<LocationState, Error>
    
    init() {
        //self.store = store
    }
    
    func configureEventSource(dispatch: @escaping Closure<MapState.Event>) {
        //store.statePublisher
    }
}
