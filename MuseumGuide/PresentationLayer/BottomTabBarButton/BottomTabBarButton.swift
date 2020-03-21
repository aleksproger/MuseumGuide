//
//  BottomTabBarButton.swift
//  MuseumGuide
//
//  Created by Alex on 12.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

@IBDesignable
public class BottomTabBarButton: UIButton {
    var radius: CGFloat = 35.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.setImage(UIImage(named: "map_icon"), for: .normal)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented!")
    }
    
    public override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}
