//
//  AppCoordinator.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import DITranquillity

class AppCoordinator: Loggable {
    var defaultLoggingTag: LogTag { .service }
    
    public static var shared: AppCoordinator!
    public let container: DIContainer
    
    init(window: UIWindow) {
        self.container = self.configureDependencies()
        //self.router = AppRouter(window: window)
        self.log(.debug, "Dependencies are configured")
    }
    
    private func configureDependencies() -> DIContainer {
        let container = DIContainer()
        container.append(framework: AppFramework.self)
        if !container.validate() {
            fatalError()
        }
        return container
    }
}
