//
//  URLParameterEncoder.swift
//  MuseumGuide
//
//  Created by Alex on 24.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

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
                print("[LOG:] [urlEncoder] - EncodedURLRequest -> \(encodedRequest.debugDescription)")
                if encodedRequest.value(forHTTPHeaderField: "ContentT-ype") == nil {
                    encodedRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "ContentT-ype")
                }
            }
            promise(.success(encodedRequest))
        }.eraseToAnyPublisher()
    }
}
