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
    private let typesView = TypesView()
    
    struct Info {
        let types: [String]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTypesView()
        setupSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with info: Info) {
        let types = info.types.compactMap { title -> TypeCell.Info? in
            let width = TypeCell.size(for: title)
            guard let type = PlaceType(rawValue: title) else {
                return nil
            }
            return TypeCell.Info(type: type, size: CGSize(width: width, height: TypeCell.height))

        }
        typesView.updateDataSource(types)
    }
    
    private func setupTypesView() {
        addSubview(typesView)

        typesView.translatesAutoresizingMaskIntoConstraints = false
        typesView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        typesView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        typesView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        typesView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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
