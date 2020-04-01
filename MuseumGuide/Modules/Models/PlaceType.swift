//
//  PlaceType.swift
//  MuseumGuide
//
//  Created by Alex on 01.04.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

enum PlaceType: String {
    case museum = "Музей"
    case music = "Музыка"
    case art = "Архитектура"
    case travel = "Путешествия"
    case science = "Наука"
    
    var color: UIColor {
        switch self {
        case .music:
            return .systemRed
        case .art:
            return .amethyst
        case .travel:
            return .belizeHole
        case .science:
            return .concrete
        case .museum:
            return .carrot
        }
    }
}
