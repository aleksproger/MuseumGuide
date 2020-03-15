//
//  UIWindow+VisibleVc.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewControllerFrom(self.rootViewController)
    }
    
    public static func visibleViewControllerFrom(_ controller: UIViewController?) -> UIViewController? {
        if let nc = controller as? UINavigationController {
            return UIWindow.visibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = controller as? UITabBarController {
            return UIWindow.visibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = controller?.presentedViewController {
                return UIWindow.visibleViewControllerFrom(pvc)
            } else {
                return controller
            }
        }
    }
}
