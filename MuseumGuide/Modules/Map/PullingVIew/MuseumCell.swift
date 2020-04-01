//
//  MuseumCell.swift
//  MuseumGuide
//
//  Created by Alex on 28.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class MuseumCell: UITableViewCell {
    
    struct Layout {
        static let inset: CGFloat = 18
        static let shapeSize: CGFloat = 48
        static let estimatedHeight: CGFloat = 40
    }
    
    struct Info {
        var title: String
        var subtitle: String
    }
    
    private let button = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var info: Info?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with info: Info) {
        self.info = info
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(button)

        
        button.setImage(UIImage(named: "map_icon"), for: .normal)
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
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
        let buttonSize = Layout.shapeSize
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: button.rightAnchor, constant: inset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.leftAnchor.constraint(equalTo: button.rightAnchor, constant: inset).isActive = true
        subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc private func handleButton(sender: UIButton) {
        sender.bounce()
    }
}

extension MuseumCell {
    
    static func makeDefaultInfos() -> [CellModel] {
        return [
            CellModel.info(MuseumCell.Info(title: "Circle",
                subtitle: "A circle is a simple closed shape. It is the set of all points in a plane that are at a given distance from a given point, the centre; equivalently it is the curve traced out by a point that moves so that its distance from a given point is constant.")),
            
            CellModel.info(MuseumCell.Info(title: "Triangle",
                            subtitle: "A triangle is a polygon with three edges and three vertices. It is one of the basic shapes in geometry.")),
            
            CellModel.info(MuseumCell.Info(title: "Square",
            subtitle: "In geometry, a square is a regular quadrilateral, which means that it has four equal sides and four equal angles (90-degree angles, or (100-gradian angles or right angles)."))

            
        ]
    }
}
