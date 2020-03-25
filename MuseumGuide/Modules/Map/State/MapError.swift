//
//  MapError.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

enum MapError: Error {
    case servicesNotEnabled
    case noMuseums
    case other(_ description: String)
}
