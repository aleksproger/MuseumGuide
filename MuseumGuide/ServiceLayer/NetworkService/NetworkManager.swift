//
//  NetworkManager.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

class NetworkManager {
    let environment: NetworkEnvironment = .production
    let networkService = NetworkService()
    private var subscriptions = Set<AnyCancellable>()
    
    enum NetworkResponseError: String, Error {
        case authenticationError = "You need to be authenticated first."
        case badRequest = "Bad request."
        case outdated = "The URL outdated."
        case failed = "Network request failed."
        case noData = "Response returned with no data to decode."
        case unableToDecode = "Couldn't decode the response."
        case success = "Success."
    }
    
    func getRandomBeer() -> AnyPublisher<[Beer], NetworkError> {
        return Future { [unowned self] promise in
            self.requestBeer()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                }, receiveValue: { response in
                    if case .failure(let error) = self.handleNetworkResponse(response.response as! HTTPURLResponse) {
                        let errorText = error.rawValue
                        promise(.failure(.responseError(errorText)))
                    }
                    promise(.success(response.value))
                })
                .store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }

    private func requestBeer() -> AnyPublisher<Response<BeerResponse>, NetworkError> {
        networkService.request(BeerAPI.randomBeer)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String, NetworkResponseError> {
        switch response.statusCode {
        case 200...299: return .success("Success.")
        case 401...500: return .failure(NetworkResponseError.authenticationError)
        case 501...599: return .failure(NetworkResponseError.badRequest)
        case 600: return .failure(NetworkResponseError.outdated)
        default: return .failure(NetworkResponseError.failed)
        }
    }

}
