//
//  AppRouter.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

public class AppRouter {
    private let window: UIWindow
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func openMap() {
        let mapModule = MapAssembly.createModule()
        WindowRouter(target: mapModule, window: window).move()
    }
    
    func openContainer() {
        let containerModule = ContainerAssembly.createModule()
        WindowRouter(target: containerModule, window: window).move()

    }
}
