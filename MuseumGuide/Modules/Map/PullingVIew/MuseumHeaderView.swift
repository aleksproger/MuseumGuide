//
//  MuseumHeaderView.swift
//  MuseumGuide
//
//  Created by Alex on 27.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import pop
import SkeletonView

final class MuseumHeaderView: UIView {
    private let button = UIButton(type: .system)
    private let separator = UIView()
    
    struct Info {
        let title: String
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupButton()
        setupSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with info: Info) {
        button.setTitle(info.title, for: .normal)
        button.titleLabel?.hideSkeleton(transition: .crossDissolve(0.25))
    }
    
    private func setupButton() {
        addSubview(button)
        button.tintColor = .black
        button.backgroundColor = .white
        button.setTitle("Информация", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets.left = 16
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.isSkeletonable = true
        button.titleLabel?.isSkeletonable = true


        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func setupSeparator() {
        addSubview(separator)
        separator.backgroundColor = UIColor(white: 0.8, alpha: 0.5)

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
    }
    
    private func bounceButton() {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        animation.velocity = CGPoint(x: 8, y: 8)
        animation.springBounciness = 20
        animation.fromValue = CGPoint(x: 1.1, y: 1.1)
        animation.toValue = CGPoint(x: 1, y: 1)
        button.layer.pop_add(animation, forKey: kPOPLayerScaleXY)
    }
    
    @objc private func handleButton() {
        //bounceButton()
    }
}
