//
//  URLParameterEncoder.swift
//  MuseumGuide
//
//  Created by Alex on 24.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

public protocol ParameterEncoder: Loggable {
    static func encode(request: URLRequest, with parameters: NetworkService.Parameters?) -> AnyPublisher<URLRequest, NetworkError>
}

extension ParameterEncoder {
    public var defaultLoggingTag: LogTag { .parameterEncoder }
}


public class URLParameterEncoder: ParameterEncoder {
    public static func encode(request: URLRequest, with parameters: NetworkService.Parameters?) -> AnyPublisher<URLRequest, NetworkError>{
        return Future { promise in
            guard let url = request.url else {
                promise(.failure(.missingURL))
                return
            }
            guard let parameters = parameters else {
                promise(.success(request))
                return
            }
            var encodedRequest = request
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                urlComponents.queryItems = [URLQueryItem]()
                for (key, value ) in parameters {
                    urlComponents.queryItems?.append(URLQueryItem(name: key, value: "\(value)"))
                }
                encodedRequest.url = urlComponents.url
                print("EncodedRequest: URL -> \(encodedRequest.url), PARAMS: \(encodedRequest.debugDescription)")
                if encodedRequest.value(forHTTPHeaderField: "ContentT-ype") == nil {
                    encodedRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentT-ype")
                }
            }
            promise(.success(encodedRequest))
        }.eraseToAnyPublisher()
    }
}

public class JSONParameterEncoder: ParameterEncoder {
    public static func encode(request: URLRequest, with parameters: NetworkService.Parameters?) -> AnyPublisher<URLRequest, NetworkError>{
        return Future { promise in
            guard let parameters = parameters else { return promise(.success(request)) }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) else { return  promise(.failure(.encodingFailed)) }
            var encodedRequest = request
            encodedRequest.httpBody = jsonData
            if encodedRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                encodedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            promise(.success(encodedRequest))
        }.eraseToAnyPublisher()
    }
}
