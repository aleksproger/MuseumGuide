//
//  LocationError.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case locationServicesNotEnabled
    case noLocation
    case other(_ description: String)
}
