//
//  MuseumHeaderView.swift
//  MuseumGuide
//
//  Created by Alex on 27.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

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
    }
    
    private func setupButton() {
        addSubview(button)
        button.tintColor = .black
        button.backgroundColor = .white
        button.setTitle("Museum info", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets.left = 16
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.isUserInteractionEnabled = false

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
    
    @objc private func handleButton() {
        
    }
}
