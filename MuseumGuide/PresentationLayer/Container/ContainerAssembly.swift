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
        container.register {
            ContainerView.loadFromStoryboard(storyboardType: .main, identifier: String(describing: ContainerView.self))
        }
            .lifetime(.objectGraph)
    }
}

final class ContainerAssembly {
    class func createModule() -> ContainerView {
        return AppCoordinator.shared.container.resolve()
    }
}
