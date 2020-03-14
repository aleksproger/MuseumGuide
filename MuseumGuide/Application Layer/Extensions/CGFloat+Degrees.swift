//
//  CGFloat+Degrees.swift
//  MuseumGuide
//
//  Created by Alex on 14.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
