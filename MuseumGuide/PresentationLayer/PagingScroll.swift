//
//  PagingScroll.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit
import pop

class PagingScroll: UIView {
    let contentView: UIScrollView
    var anchors: [CGPoint] = []
    static let animationKey = "ScrollView.AnimationKey"
    
    var decelerationRate: CGFloat = UIScrollView.DecelerationRate.fast.rawValue
    var springBounciness: CGFloat = 7.5
    var springSpeed: CGFloat = 7.5
    
    init(contentView: UIScrollView) {
        self.contentView = contentView
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contentViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // Stop system animation
        targetContentOffset.pointee = scrollView.contentOffset
    
        let offsetProjection = scrollView.contentOffset.project(initialVelocity: velocity,
            decelerationRate: decelerationRate)
        
        if let target = nearestAnchor(forContentOffset: offsetProjection) {
            snapAnimated(toContentOffset: target, velocity: velocity)
        }
    }
    
    func contentViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopSnappingAnimation()
    }
}

private extension PagingScroll {
    
    var minAnchor: CGPoint {
        let x = -contentView.adjustedContentInset.left
        let y = -contentView.adjustedContentInset.top
        return CGPoint(x: x, y: y)
    }
    
    var maxAnchor: CGPoint {
        let x = contentView.contentSize.width - bounds.width + contentView.adjustedContentInset.right
        let y = contentView.contentSize.height - bounds.height + contentView.adjustedContentInset.bottom
        return CGPoint(x: x, y: y)
    }
        
    func nearestAnchor(forContentOffset offset: CGPoint) -> CGPoint? {
        guard let candidate = anchors.min(by: { offset.distance(to: $0) < offset.distance(to: $1) }) else {
            return nil
        }
        
        let x = candidate.x.clamped(to: minAnchor.x...maxAnchor.x)
        let y = candidate.y.clamped(to: minAnchor.y...maxAnchor.y)
        
        return CGPoint(x: x, y: y)
    }
    
    func setupViews() {
        addSubview(contentView)
        setupLayout()
    }
    
    func setupLayout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func snapAnimated(toContentOffset newOffset: CGPoint, velocity: CGPoint) {
        let animation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPScrollViewContentOffset)
        animation.velocity = velocity
        animation.toValue = newOffset
        animation.fromValue = contentView.contentOffset
        animation.springBounciness = springBounciness
        animation.springSpeed = springSpeed
     
        contentView.pop_add(animation, forKey: PagingScroll.animationKey)
    }
    
    private func stopSnappingAnimation() {
        contentView.pop_removeAnimation(forKey: PagingScroll.animationKey)
    }
    
}
