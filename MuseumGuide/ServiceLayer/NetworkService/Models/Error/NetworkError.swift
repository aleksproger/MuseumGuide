//
//  NetworkError.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case parametersNil
    case encodingFailed
    case missingURL
    case responseError(_ error: String)
    case decodingFailed
}
