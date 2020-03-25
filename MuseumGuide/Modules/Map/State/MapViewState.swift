//
//  MapViewState.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation

enum MapViewState: ViewState {
    case fetching
    case fetched([CLLocation])
    case error(Error?)
    
    init(domainState: MapState) {
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
