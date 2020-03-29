////
////  MapPresenterState.swift
////  MuseumGuide
////
////  Created by Alex on 29.03.2020.
////  Copyright © 2020 Alex. All rights reserved.
////
//
//import Foundation
//import Mapbox
//
//enum MapPresenterState: State {
//    
//    //MARK: - Cases
//    
//    case idle
//    case fetching
//    case fetched([Museum])
//    case transformed([])
//    case error
//    
//    //MARK: - Enums
//    
//    enum Event: Equatable {
//        case fetchMuseums
//        case fetched([Museum])
//        case transformedToFeatures([MGLPointFeature])
//    }
//    
//    enum Effect: Equatable {
//        case determineLocation
//        case transformToFeatures([Museum])
//    }
//    
//    //MARK: - Properties
//    
//    static var initialState: MapPresenterState { .idle }
//    
//    //MARK: - Methods
//    
//    mutating func handle(event: Event) -> Effect? {
//        switch (self, event) {
//        case (.fetching, .fetchMuseums):
//            fatalError()
//        case (_, .fetchMuseums):
//            self = .fetching
//            return nil
//        case(_, .fetched(let museums)):
//            self = .fetched(museums)
//            return .transformToFeatures(museums)
//        case(_, .transformedToFeatures(let features)):
//            self.
//        }
//        return nil
//    }
//    
//}
