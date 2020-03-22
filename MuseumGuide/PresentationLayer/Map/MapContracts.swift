//
//  MapContracts.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation

protocol MapEventHandler: ViewControllerEventHandler {
    func setLocation(location: CLLocation)
}

protocol MapViewBehavior: class {
    
}
