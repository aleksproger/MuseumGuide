//
//  UITabBarItem_Layout.swift
//  MuseumGuide
//
//  Created by Alex on 14.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarItem {
    func customOffset(for index: Int) -> UIOffset{
        switch index {
            case 0: return UIOffset.init(horizontal: -10.0, vertical: 0.0)
            case 1: return UIOffset.init(horizontal: -25.0, vertical: 0.0)
            case 2: return UIOffset.init(horizontal: 25.0, vertical: 0.0)
            case 3: return UIOffset.init(horizontal: 10.0, vertical: 0.0)
            default: return UIOffset.init(horizontal: 0.0, vertical: 0.0)
        }
    }
    func customInsets(for index: Int) -> UIEdgeInsets{
        switch index {
            case 0: return UIEdgeInsets(top: 0.0, left: 10.0 , bottom: 0, right: 0)
            case 1: return  UIEdgeInsets(top: 0.0, left: 25.0 , bottom: 0, right: 0)
            case 2: return  UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0, right: 25.0)
            case 3: return  UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0, right: 10.0)
            default: return UIEdgeInsets(top: 0.0, left: 0.0 , bottom: 0, right: 0.0)
        }
    }
}
