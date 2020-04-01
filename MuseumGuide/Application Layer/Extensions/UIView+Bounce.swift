//
//  UIView+Bounce.swift
//  MuseumGuide
//
//  Created by Alex on 31.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import pop

extension UIView {
    func bounce(velocity: CGPoint = CGPoint(x: 8, y: 8), bounciness: CGFloat = 20) {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        animation.velocity = velocity
        animation.springBounciness = bounciness
        animation.fromValue = CGPoint(x: 1.1, y: 1.1)
        animation.toValue = CGPoint(x: 1, y: 1)
        self.layer.pop_add(animation, forKey: kPOPLayerScaleXY)
    }
}
