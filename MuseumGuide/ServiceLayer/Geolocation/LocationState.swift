//
//  LocationState.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationState: State {
    //MARK: - Cases
    
    case idle
    case loading
    case loaded(CLLocation)
    case error
    
    //MARK: - Enums
    
    enum Event: Equatable {
        case fetchLocation
        case fetched(location: CLLocation)
    }
    
    enum Effect: Equatable {
        case determineLocation
    }
    
    //MARK: - Properties
    
    static var initialState: LocationState { .idle }
    
    //MARK: - Methods
    
    mutating func handle(event: Event) -> Effect? {
        switch (self, event) {
        case (.loading, .fetchLocation):
            fatalError()
        case (_, .fetchLocation):
            self = .loading
            return .determineLocation
        case(_, .fetched(let location)):
            self = .loaded(location)
        }
        return nil
    }
    
}

//extension LocationState {
//    var location: CLLocation? {
//        switch self {
//        case .idle, .loading, .error:
//            return nil
//        case .loaded(let location):
//            return location
//        }
//    }
//}
