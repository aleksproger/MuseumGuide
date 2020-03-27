//
//  TestAPI.swift
//  MuseumGuide
//
//  Created by Alex on 25.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
public enum BeerAPI {
    case randomBeer
    case beerFor(food: String, page: Int)
}

extension BeerAPI: APIRequest {
    var baseURL: URL {
      return URL(string: "https://api.punkapi.com/v2/beers/")!
    }
    
    var path: String {
        switch self {
        case .randomBeer: return "ra nd?om"
        case .beerFor(food: _): return .emptyLine
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
        case .beerFor(let food, let page):
            return .requestParameters(bodyParameters: nil, urlParameters: ["food": food,
                                                                           "page": page])
        default:
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

public enum MuseumAPI {
    case getMuseums
}


extension MuseumAPI: APIRequest {
    var baseURL: URL {
        return URL(string: "http://localhost:8080/")!
    }
    
    var path: String {
        .emptyLine
    }
    
    var httpMethod: NetworkService.HTTPMethod {
        .GET
    }
    
    var headers: NetworkService.HTTPHeaders? {
        nil
    }
    
    var task: NetworkService.HTTPTask {
        .request
    }
}

struct Museum: Codable {
    let name: String
    let lat: Double
    let lon: Double
    enum MuseumCodingKeys: String, CodingKey {
        case name, lat, lon
    }
    init(from decoder: Decoder) throws {
        let museumContainer = try decoder.container(keyedBy: MuseumCodingKeys.self)
        name = try museumContainer.decode(String.self, forKey: .name)
        let lattitude = try museumContainer.decode(String.self, forKey: .lat)
        let longtitude = try museumContainer.decode(String.self, forKey: .lon)
        lat = Double(lattitude)!
        lon = Double(longtitude)!
    }
}

typealias MuseumResponse = [Museum]
