//
//  APIRequest.swift
//  MuseumGuide
//
//  Created by Alex on 23.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol APIRequest {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: NetworkService.HTTPMethod { get }
    var headers: NetworkService.HTTPHeaders? { get }
    var task: NetworkService.HTTPTask { get }
}

public enum BeerAPI {
    case randomBeer
}

extension BeerAPI: APIRequest {
    var baseURL: URL {
        switch self {
        case .randomBeer: return URL(string: "https://api.punkapi.com/v2/beers/")!
        }
    }
    
    var path: String {
        switch self {
        case .randomBeer: return "random"
        }
    }
    
    var httpMethod: NetworkService.HTTPMethod {
        return .GET
    }
    
    var headers: NetworkService.HTTPHeaders? {
        nil
    }
    
    var task: NetworkService.HTTPTask {
        switch self {
        case .randomBeer:
            return .request
        }
    }
}

struct Beer: Codable {
    let name: String
    let description: String
    
    enum BeerCodingKeys: String, CodingKey {
        case name, description
    }
    
    init(from decoder: Decoder) throws {
        let beerContainer = try decoder.container(keyedBy: BeerCodingKeys.self)
        name = try beerContainer.decode(String.self, forKey: .name)
        description = try beerContainer.decode(String.self, forKey: .description)
    }
}

typealias BeerResponse = [Beer]

