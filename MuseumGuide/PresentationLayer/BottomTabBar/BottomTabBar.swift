//
//  BottomTabBar.swift
//  MuseumGuide
//
//  Created by Alex on 11.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

@IBDesignable
class BottomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    private var centerButton: BottomTabBarButton?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.centerButton = BottomTabBarButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        setupView()
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
        guard let button = centerButton else {
            return
        }
        //self.addSubview(button)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35.0
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }
    
    private func setupView() {
        guard let items = items, let button = centerButton else {
            return
        }
//        addSubview(button)
        for (index, item) in items.enumerated() {
            item.titlePositionAdjustment = item.customOffset(for: index)
//            item.imageInsets = item.customInsets(for: index)
        }
    }
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    private func createPath() -> CGPath {
        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.bounds.width / 2
        
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: centerWidth - radius * 2, y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.close()
        return path.cgPath
    }
}
