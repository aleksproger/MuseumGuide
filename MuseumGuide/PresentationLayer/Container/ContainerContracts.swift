//
//  ContainerContracts.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import CoreLocation

protocol ContainerViewRouting {
    func openMap()
}

protocol ContainerEventHandler: ViewControllerEventHandler {
    func handleTap()
}

protocol ContainerViewBehavior: class{
    func handleTap()
}
