//
//  ContainerPresenter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class ContainerPresenter: ContainerEventHandler {
    weak var view: ContainerViewBehavior!
    var router: ContainerRouter
    
    init(view: ContainerViewBehavior, router: ContainerRouter) {
        self.view = view
        self.router = router
    }
    
    func handleTap() {
        //openMap()
    }
}
