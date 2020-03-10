//
//  BaseNavigationViewController.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    var isInteractivePopEnabled: Bool = true
    var tabs: Int?
    
    convenience init(rootViewController: UIViewController, tabs: Int) {
         self.init(rootViewController: rootViewController)
         self.tabs = tabs
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .portrait }
    
    override var shouldAutorotate: Bool { false }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        super.popToRootViewController(animated: animated)
    }
    
    
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    
}
