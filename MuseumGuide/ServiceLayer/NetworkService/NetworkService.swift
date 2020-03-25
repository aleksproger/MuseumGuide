//
//  NetworkService.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

public struct Response<T> {
    let value: T
    let response: URLResponse
}

public class NetworkService: Loggable {
    public var defaultLoggingTag: LogTag { .networkService }
    
    public typealias HTTPHeaders = [String: String]
    public typealias Parameters = [String: Any]
    public let successCodes: CountableRange<Int> = 200..<299
    public let failureCodes: CountableRange<Int> = 400..<499
    public enum HTTPMethod: String {
        case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
    }
    public enum HTTPTask {
        case request
        case requestParameters(bodyParameters: Parameters?,
            urlParameters: Parameters)
        case requestParametersAndHeaders(bodyParameters: Parameters?,
            urlParameters: Parameters,
            additionalHeaders: HTTPHeaders)
    }


    private static let Timeout: TimeInterval = 50
    private lazy var session = URLSession(configuration: configuration())
    private func configuration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = NetworkService.Timeout
        configuration.timeoutIntervalForResource = NetworkService.Timeout
        return configuration
    }
    
    func request<T: Codable>(_ request: APIRequest) -> AnyPublisher<Response<T>, NetworkError> {
        createURLRequest(from: request)
            .flatMap(maxPublishers: .max(1)) { request in
                URLSession.shared.dataTaskPublisher(for: request)
                .mapError { error -> NetworkError in
                         return NetworkError.responseError(error: error)
                }
            }
            .tryMap { result -> Response<T> in
                let value: T = try JSONDecoder.init().decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .mapError { error -> NetworkError in
                NetworkError.decodingFailed
            }
            .eraseToAnyPublisher()
    }


    private func createURLRequest(from route: APIRequest) -> AnyPublisher<URLRequest, NetworkError> {
        let url = route.baseURL.appendingPathComponent(route.path)
        log(.debug, "URL -> \(url)")
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: NetworkService.Timeout)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return Just(request)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        case .requestParameters(let bodyParameters, let urlParameters):
            return configureParameters(bodyParameters: bodyParameters, urlParameters:                                    urlParameters, request: request)
                                       .eraseToAnyPublisher()
        case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
            return addAdditionalHeader(additionalHeaders, request: request)
                .setFailureType(to: NetworkError.self)
                .flatMap { [unowned self] request in
                    self.configureParameters(bodyParameters: bodyParameters,
                                             urlParameters: urlParameters,
                                             request: request)
                }.eraseToAnyPublisher()
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                                     urlParameters: Parameters?,
                                     request: URLRequest) -> AnyPublisher<URLRequest, NetworkError> {
        log(.debug, "BodyParameters ->\(String(describing: bodyParameters))")
        log(.debug, "URLParameters ->\(String(describing: urlParameters))")
        return URLParameterEncoder.encode(request: request, with: urlParameters)
            .flatMap { request in
                JSONParameterEncoder.encode(request: request, with: bodyParameters)
            }
            .print()
            .eraseToAnyPublisher()
    }
    
    private func addAdditionalHeader(_ additionalHeaders: HTTPHeaders?, request: URLRequest) -> AnyPublisher<URLRequest, Never> {
        return Future { promise in
            guard let headers = additionalHeaders else {
                promise(.success(request))
                return
            }
            var encodedRequest = request
            for (key, value) in headers {
                encodedRequest.setValue(value, forHTTPHeaderField: key)
            }
            promise(.success(encodedRequest))
        }.eraseToAnyPublisher()
    }
}
