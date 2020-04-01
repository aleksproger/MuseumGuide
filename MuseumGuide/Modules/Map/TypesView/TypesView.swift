//
//  TypesView.swift
//  MuseumGuide
//
//  Created by Alex on 30.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import pop

class TypesView: PagingScroll {
    
    private enum Layout {
        static let cellSpacing: CGFloat = 8
    }
    
    private var collectionView: UICollectionView { contentView as! UICollectionView }
    private var dataSource: [TypeCell.Info] = TypeCell.makeCellInfos() {
        didSet {
            anchors = (0..<dataSource.count).map {
                let offsetX: CGFloat = dataSource.prefix($0).reduce(0, {
                    return $0 + $1.size.width + Layout.cellSpacing
                })
                return CGPoint(x: offsetX, y: 0)
            }
        }
    }

    
    override init(contentView: UIScrollView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())) {
        super.init(contentView: contentView)
        collectionView.register(TypeCell.self, forCellWithReuseIdentifier: "\(TypeCell.self)")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDataSource(_ data: [TypeCell.Info]) {
        dataSource = data
        collectionView.reloadData()
    }
    
   private static func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.cellSpacing
        layout.sectionInset = UIEdgeInsets(top: Layout.cellSpacing, left: Layout.cellSpacing, bottom: Layout.cellSpacing, right: Layout.cellSpacing)
        layout.scrollDirection = .horizontal
        return layout
    }

}

extension TypesView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell
    {
        let cellModel = dataSource[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TypeCell.self)", for: indexPath) as! TypeCell
        cell.update(with: TypeCell.Info(text: cellModel.text, size: cellModel.size))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.bounce(velocity: CGPoint(x: 4, y: 4))
    }
}



extension TypesView: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return dataSource[indexPath.item].size
    }
   
   func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
       targetContentOffset: UnsafeMutablePointer<CGPoint>)
   {
       contentViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
   }
   
   func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      contentViewWillBeginDragging(scrollView)
    }
}

