//
//  NetworkManager.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

class NetworkManager: Loggable {
    public var defaultLoggingTag: LogTag { .networkManager }
    
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
                .sink(receiveCompletion: { [unowned self] completion in
                    if case .failure(let error) = completion {
                        self.log(.debug, "Error -> \(error.errorDescription ?? .emptyLine)")
                        promise(.failure(error))
                    }
                }, receiveValue: { [unowned self] response in
                    if case .failure(let error) = self.handleNetworkResponse(response.response as! HTTPURLResponse) {
                        let errorText = error.rawValue
                        self.log(.debug, "Error -> \(errorText)")
                        promise(.failure(.responseError(errorText)))
                    }
                    promise(.success(response.value))
                })
                .store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getBeerFor(for food: String) -> AnyPublisher<[Beer], NetworkError> {
        return Future { [unowned self] promise in
            self.requestBeer(for: food)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.log(.debug, "Error -> \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }, receiveValue: { response in
                    if case .failure(let error) = self.handleNetworkResponse(response.response as! HTTPURLResponse) {
                        let errorText = error.rawValue
                        self.log(.debug, "Error -> \(errorText)")
                        promise(.failure(.responseError(errorText)))
                    }
                    promise(.success(response.value))
                })
                .store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
    
    func getMuseums() -> AnyPublisher<[Museum], NetworkError> {
        return Future { [unowned self] promise in
            self.requestMuseums()
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.log(.debug, "Error -> \(error.localizedDescription)")
                        promise(.failure(error))
                    }
                }, receiveValue: { response in
                    if case .failure(let error) = self.handleNetworkResponse(response.response as! HTTPURLResponse) {
                        let errorText = error.rawValue
                        self.log(.debug, "Error -> \(errorText)")
                        promise(.failure(.responseError(errorText)))
                    }
                    promise(.success(response.value))
                })
                .store(in: &self.subscriptions)
        }.eraseToAnyPublisher()
    }
}

private extension NetworkManager {
    private func requestBeer() -> AnyPublisher<Response<BeerResponse>, NetworkError> {
        networkService.request(BeerAPI.randomBeer)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func requestBeer(for food: String, page: Int = 1) -> AnyPublisher<Response<BeerResponse>, NetworkError> {
        networkService.request(BeerAPI.beerFor(food: food, page: page))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func requestMuseums() -> AnyPublisher<Response<MuseumResponse>, NetworkError> {
        networkService.request(MuseumAPI.getMuseums)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension NetworkManager {
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
