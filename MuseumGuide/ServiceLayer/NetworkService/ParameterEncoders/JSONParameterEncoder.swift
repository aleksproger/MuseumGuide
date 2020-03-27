//
//  JSONParameterEncoder.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

public class JSONParameterEncoder: ParameterEncoder {
    public static func encode(request: URLRequest, with parameters: NetworkService.Parameters?) -> AnyPublisher<URLRequest, NetworkError>{
        return Future { promise in
            guard let parameters = parameters else { return promise(.success(request)) }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return  promise(.failure(.encodingFailed)) }
            var encodedRequest = request
            encodedRequest.httpBody = jsonData
            print("[LOG:] [jsonencoder] - EncodedJSONRequest -> \(encodedRequest.debugDescription)")
            if encodedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                encodedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            promise(.success(encodedRequest))
        }.eraseToAnyPublisher()
    }
}
