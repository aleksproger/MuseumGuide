//
//  PushRouter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

public class PushRouter {
    let target: UIViewController
    let parent: UIViewController

    init(target: UIViewController, parent: UIViewController) {
        self.target = target
        self.parent = parent
    }

    public func move() {
        if let nc = parent.navigationController {
            self.present(self.target, using: nc)
        }
    }

    private func present(_ controller: UIViewController, using ncontroller: UINavigationController) {
        if ncontroller.topViewController != controller {
            ncontroller.pushViewController(controller, animated: true)
        }
    }
}
