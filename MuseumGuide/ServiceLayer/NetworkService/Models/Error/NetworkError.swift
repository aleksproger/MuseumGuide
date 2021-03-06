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

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .parametersNil:
            return "Nil parameters passed."
        case .decodingFailed:
            return "Decoding failed."
        case .encodingFailed:
            return "Encoding failed."
        case .missingURL:
            return "Nil URL passed."
        case .responseError(let errorText):
            return "Response error occured: \(errorText)"
        }
    }
}
