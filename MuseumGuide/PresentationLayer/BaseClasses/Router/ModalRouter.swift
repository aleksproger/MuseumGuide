//
//  ModalRouter.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

public class ModalRouter{
    let target: UIViewController
    let parent: UIViewController?

    init(target: UIViewController, parent: UIViewController?) {
        self.target = target
        self.parent = parent
    }
    
    public func push() {
        if !(target is UINavigationController),
           let parent = parent,
           let navigationController = parent.navigationController {
            
            parent.navigationItem.backBarButtonItem?.title = " "
            navigationController.pushViewController(target, animated: true)
        } else {
            self.move()
        }
    }
    
    public func move() {
        if let vc = parent {
            self.presentModal(self.target, from: vc)
        } else {
            self.presentModal(self.target)
        }
    }

    private func presentModal(_ controller: UIViewController, from parent: UIViewController) {
        parent.present(controller, animated: true, completion: {})
    }

    private func presentModal(_ controller: UIViewController) {
        UIApplication.shared.visibleViewController?.present(controller, animated: true)
    }
}
