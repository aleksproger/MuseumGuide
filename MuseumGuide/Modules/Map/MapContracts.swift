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
import UltraDrawerView


protocol MapEventHandler: ViewControllerEventHandler {
    var tableViewWorker: TableViewWorker { get }
    var pullingViewWorker: PullingViewWorker { get }
    func handleMapTap(sender: UITapGestureRecognizer)
    func deselectAnnotation()
}

protocol MapViewBehavior: class {
    
}

protocol TableViewWorker: NSObject, UITableViewDelegate, UITableViewDataSource {
    func updateDataSource(with data: [CellModel])
}

protocol PullingViewWorker: DrawerViewListener {
    var handler: MapEventHandler? { get }
}
