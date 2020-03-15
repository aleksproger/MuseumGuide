//
//  UIApplication+VisibleVC.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    var visibleViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return getVisibleViewController(visibleViewController)
        }
        
        if let tabBarController = rootViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return getVisibleViewController(selectedViewController)
        }
        
        return rootViewController
    }
}
