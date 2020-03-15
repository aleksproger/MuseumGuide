//
//  ContainerView.swift
//  MuseumGuide
//
//  Created by Alex on 11.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class ContainerView: UITabBarController, ContainerViewBehavior, Loggable {
    var defaultLoggingTag: LogTag = .viewController
    
    @IBOutlet weak var bottomTabBar: BottomTabBar!
    var handler: ContainerEventHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log(.debug, "ContainerView didLoad")
        self.bottomTabBar.handleTap = { [weak self] in
            self?.handleTap()
        }
    }
    
    func handleTap() {
        handler.handleTap()
    }
    
}
