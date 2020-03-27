//
//  MuseumCell.swift
//  MuseumGuide
//
//  Created by Alex on 27.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import pop

final class ShapeCell: UITableViewCell {
    
    struct Info {
        var title: String
        var subtitle: String
        var shape: UIBezierPath
    }
    
    struct Layout {
        static let inset: CGFloat = 18
        static let shapeSize: CGFloat = 48
        static let estimatedHeight: CGFloat = 40
    }
    
    private let shapeButton = UIButton()
    private let shapeLayer = CAShapeLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var info: Info? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = shapeButton.bounds
    }
    
    func update(with info: Info) {
        self.info = info
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
        shapeLayer.path = info.shape.cgPath
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(shapeButton)
        shapeButton.addTarget(self, action: #selector(handleShapeButton), for: .touchUpInside)
        
        shapeButton.layer.addSublayer(shapeLayer)
        shapeLayer.lineWidth = 5
        shapeLayer.lineJoin = .round
        updateShapeColors()
        
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        addSubview(subtitleLabel)
        subtitleLabel.font = .systemFont(ofSize: UIFont.systemFontSize)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkGray
        
        setupLayout()
    }
    
    private func setupLayout() {
        let inset = Layout.inset
        let shapeSize = Layout.shapeSize
        
        shapeButton.translatesAutoresizingMaskIntoConstraints = false
        shapeButton.widthAnchor.constraint(equalToConstant: shapeSize).isActive = true
        shapeButton.heightAnchor.constraint(equalToConstant: shapeSize).isActive = true
        shapeButton.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        shapeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: shapeButton.rightAnchor, constant: inset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leftAnchor.constraint(equalTo: shapeButton.rightAnchor, constant: inset).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func updateShapeColors() {
        shapeLayer.fillColor = UIColor.randomExtraLight.cgColor
        shapeLayer.strokeColor = UIColor.randomDark.cgColor
    }
    
    private func bounceShape() {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        animation.velocity = CGPoint(x: 8, y: 8)
        animation.springBounciness = 16
        animation.fromValue = CGPoint(x: 1.1, y: 1.1)
        animation.toValue = CGPoint(x: 1, y: 1)
        shapeLayer.pop_add(animation, forKey: kPOPLayerScaleXY)
    }
    
    @objc private func handleShapeButton() {
        updateShapeColors()
        bounceShape()
    }

}

internal extension UIColor {

    convenience init(rgb value: UInt) {
        self.init(byteRed: UInt8((value >> 16) & 0xff),
            green: UInt8((value >> 8) & 0xff),
            blue: UInt8(value & 0xff),
            alpha: 0xff)
    }

    convenience init(rgba value: UInt) {
        self.init(byteRed: UInt8((value >> 24) & 0xff),
            green: UInt8((value >> 16) & 0xff),
            blue: UInt8((value >> 8) & 0xff),
            alpha: UInt8(value & 0xff))
    }
    
    convenience init(byteRed red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8 = 0xff) {
        self.init(red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0)
    }

    static var random: UIColor {
        return UIColor(red: rand(), green: rand(), blue: rand(), alpha: 1.0)
    }
    
    static var randomLight: UIColor {
        return UIColor(red: 0.8 + 0.2 * rand(), green: 0.8 + 0.2  * rand(), blue: 0.8 + 0.2 * rand(), alpha: 1.0)
    }
    static var randomExtraLight: UIColor {
        return UIColor(red: 0.92 + 0.08 * rand(), green: 0.92 + 0.08  * rand(), blue: 0.92 + 0.08 * rand(), alpha: 1.0)
    }
    
    static var randomDark: UIColor {
        return UIColor(red: 0.7 * rand(), green: 0.7 * rand(), blue: 0.7 * rand(), alpha: 1.0)
    }
    
    private static func rand() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }

}

