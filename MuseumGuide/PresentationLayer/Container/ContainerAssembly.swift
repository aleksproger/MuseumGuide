//
//  ContainerAssembly.swift
//  MuseumGuide
//
//  Created by Alex on 11.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import DITranquillity

final class ContainerPart: DIPart {
    class func load(container: DIContainer) {
        container.register(ContainerRouter.init(view:errorHandler:))
            .lifetime(.objectGraph)
        
        container.register(ContainerPresenter.init(view:router:))
            .as(ContainerEventHandler.self)
            .lifetime(.objectGraph)
        
        
        container.register {
            ContainerView.loadFromStoryboard(storyboardType: .main, identifier: String(describing: ContainerView.self))
        }
        .as(ContainerViewBehavior.self)
        .injection(cycle: true, \.handler)
        .lifetime(.objectGraph)
    }
}

final class ContainerAssembly {
    class func createModule() -> ContainerView {
        let module: ContainerView = AppCoordinator.shared.container.resolve()
        return module
    }
}
