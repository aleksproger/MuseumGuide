//
//  Response.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

public struct Response<T> {
    let value: T
    let response: URLResponse
}
