//
//  MapView.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Mapbox

class MapViewController: BaseViewController, MapViewBehavior {
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var mapTap: UITapGestureRecognizer!
    var handler: MapEventHandler!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = handler as? MGLMapViewDelegate
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserHeadingIndicator = true
        handler.didLoad()
    }
    
    //MARK: - Methods
    
    @IBAction func handleMapTap(_ sender: UITapGestureRecognizer) {
        handler.handleMapTap(sender: sender)
    }
}

