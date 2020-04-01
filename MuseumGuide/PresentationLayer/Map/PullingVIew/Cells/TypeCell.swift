//
//  TypeCell.swift
//  MuseumGuide
//
//  Created by Alex on 30.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit




final class TypeCell: UICollectionViewCell {
    
    private enum Layout {
        static let cellHeight: CGFloat = 32
        static let minCellWidth: CGFloat = 64
        static let horizontalInset: CGFloat = 32
    }
    
    struct Info {
        var text: String { type.rawValue.capitalized }
        var type: PlaceType
        var size: CGSize
    }
    
    private let textLabel = UILabel()
    static var height: CGFloat { Layout.cellHeight }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.addSubview(textLabel)
        textLabel.font = .systemFont(ofSize: 16, weight: .bold)
        textLabel.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = contentView.bounds
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
    
    func update(with info: Info) {
        textLabel.textAlignment = .center
        textLabel.text = info.text
        contentView.backgroundColor = info.type.color
    }
    
}

extension TypeCell {
    
    static func makeCellInfos() -> [TypeCell.Info] {
        return (1...100).map { _ in
            let text = "adfsdafadsfsdafasfdas" + String(Int.random(in: 1...12333))
            let size = CGSize(width: TypeCell.size(for: text), height: Layout.cellHeight)
            return TypeCell.Info(type: PlaceType.art, size: size)
        }
    }
    static func size(for text: String) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: Layout.cellHeight)
        let attrString = NSAttributedString(string: text, attributes:[NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                                                      NSAttributedString.Key.foregroundColor: UIColor.white])
        let textWidth = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.width + Layout.horizontalInset
        return textWidth
    }
}
