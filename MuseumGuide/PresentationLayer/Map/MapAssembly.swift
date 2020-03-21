//
//  MapAssembly.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import DITranquillity

final class MapPart: DIPart {
    class func load(container: DIContainer) {
        container.register {
            MapViewController.loadFromStoryboard(storyboardType: .map, identifier: String(describing: MapViewController.self))
        }
            .lifetime(.objectGraph)
    }
}

class MapAssembly {
    class func createModule() -> MapViewController {
        return AppCoordinator.shared.container.resolve()
    }
}
