//
//  LocationEvents.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class LocationEvents: EventSource {
    typealias S = LocationState
    //private let store: Store<LocationState, Error>
    
    init() {
        //self.store = store
    }
    
    func configureEventSource(dispatch: @escaping Closure<LocationState.Event>) {
        //store.statePublisher
    }
}
