//
//  Request.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

enum Request<T, E: Error> : Loggable {
    var defaultLoggingTag: LogTag { .request }
    case success(T)
    case failure(E)
}
