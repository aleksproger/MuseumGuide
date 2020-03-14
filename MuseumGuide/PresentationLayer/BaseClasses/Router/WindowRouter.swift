//
//  WindowRouter.swift
//  MuseumGuide
//
//  Created by Alex on 11.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

public final class WindowRouter {
    let target: UIViewController
    let window: UIWindow

    init(target: UIViewController, window: UIWindow) {
        self.target = target
        self.window = window
    }

    public func move() {
        self.present(self.target, using: self.window)
    }

    private func present(_ controller: UIViewController, using window: UIWindow) {
        let windows = UIApplication.shared.windows.filter {
            $0 != window
        }
        for other in windows {
            other.isHidden = true
            other.rootViewController?.dismiss(animated: false, completion: {

            })
        }
        if let old = window.rootViewController {
            old.dismiss(animated: false, completion: {
                old.view.removeFromSuperview()
            })
        }
        window.rootViewController = controller
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
