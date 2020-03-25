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
    var handler: MapEventHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = handler as? MGLMapViewDelegate
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserHeadingIndicator = true
        handler.didLoad()
    }
}

extension MapViewController: StatefulView {
    var renderPolicy: RenderPolicy {
        .possible
    }
    
    typealias State = MapViewState
    
    func render(state: MapViewState) {
        switch state {
        case .fetched(let location):
            break
//            mapView.updateUserLocationAnnotationView()

//            mapView.setCenter(location.coordinate,
                              //animated: false)
        default:
            break
        }
    }
}