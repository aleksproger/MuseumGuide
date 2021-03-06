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
        container.register(MapRouter.init(view:errorHandler:))
            .lifetime(.objectGraph)
        
        container.register(MapPresenter.init(view:router:networkManager:tableViewWorker:pullingViewWorker:))
            .as(MapEventHandler.self)
            .lifetime(.objectGraph)
        
        container.register {
            MapViewController.loadFromStoryboard(storyboardType: .main, identifier: String(describing: MapViewController.self))
        }
            .injection(cycle: true, \.handler)
            .lifetime(.objectGraph)
        
        container.register(InformationTableViewWorker.init)
            .as(TableViewWorker.self)
            .lifetime(.objectGraph)
        
        container.register(InformationViewWorker.init)
            .as(PullingViewWorker.self)
            .injection(cycle: true, \.handler)
            .lifetime(.objectGraph)
    }
}

class MapAssembly {
    class func createModule() -> MapViewController {
        let module: MapViewController = AppCoordinator.shared.container.resolve()
        return module
    }
}
