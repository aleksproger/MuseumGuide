//
//  ContainerRouter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class ContainerRouter: VIPERRouter<ContainerView> {
    func openMap() {
        let module = MapAssembly.createModule()
        PushRouter(target: module, parent: self.controller).move()
    }
}
