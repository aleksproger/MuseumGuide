//
//  ParameterEncoder.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

public protocol ParameterEncoder {
    static func encode(request: URLRequest, with parameters: NetworkService.Parameters?) -> AnyPublisher<URLRequest, NetworkError>
}
