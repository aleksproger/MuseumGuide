//
//  UIViewController+Load.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    enum StoryboardType: String {
        case main = "Main"
    }
    static func loadFromStoryboard(storyboardType: StoryboardType, identifier: String) -> Self {
        let storyboard = UIStoryboard(name: storyboardType.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: identifier) as! Self
        return vc
    }
}
