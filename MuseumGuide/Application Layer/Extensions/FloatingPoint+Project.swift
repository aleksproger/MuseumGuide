//
//  FloatingPoint+Project.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

extension FloatingPoint {
    func project(initialVelocity: Self, decelerationRate: Self) -> Self {
        if decelerationRate >= 1 {
            assert(false)
            return self
        }        
        return self + initialVelocity * decelerationRate / (1 - decelerationRate)
    }
}
