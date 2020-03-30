//
//  Comparable+Clamp.swift
//  MuseumGuide
//
//  Created by Alex on 29.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
