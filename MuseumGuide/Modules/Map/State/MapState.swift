//
//  MapState.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation

enum MapState: State {
    //MARK: - Cases
    
    case idle
    case loading
    case loaded([CLLocation])
    case error
    
    //MARK: - Enums
    
    enum Event: Equatable {
        case fetchMuseums
        case fetched(location: CLLocation)
    }
    
    enum Effect: Equatable {
        case makeRequest
    }
    
    //MARK: - Properties
    
    static var initialState: MapState { .idle }
    
    //MARK: - Methods
    
    mutating func handle(event: Event) -> Effect? {
        switch (self, event) {
        case (.loading, .fetchMuseums):
            fatalError()
        case (_, .fetchMuseums):
            self = .loading
            return .makeRequest
        case(_, .fetched(let location)):
            self = .loaded([location])
        }
        return nil
    }
    
}
