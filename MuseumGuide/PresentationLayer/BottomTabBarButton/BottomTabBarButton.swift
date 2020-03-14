//
//  BottomTabBarButton.swift
//  MuseumGuide
//
//  Created by Alex on 12.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

@IBDesignable
class BottomTabBarButton: UIButton {
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.bounds.width / 2
        self.setImage(UIImage(named: "map_icon"), for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
}
