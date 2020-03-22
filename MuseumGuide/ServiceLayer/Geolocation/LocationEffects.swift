//
//  LocationEffects.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

class LocationEffects: EffectHandler {
    
    typealias S = LocationState
    typealias E = LocationError

    private let locationService: LocationService
    
    //MARK: - Inittialization
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    //MARK: - Methods
    func handle(_ effect: LocationState.Effect) -> Future<LocationState.Event, LocationError>? {
        switch effect {
        case .determineLocation:
            return locationService.determineCoordinates()
        }
    }
}
