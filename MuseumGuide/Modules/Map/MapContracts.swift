//
//  MapContracts.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol MapEventHandler: ViewControllerEventHandler {
    func handleMapTap(sender: UITapGestureRecognizer)
}

protocol MapViewBehavior: class {
    
}
