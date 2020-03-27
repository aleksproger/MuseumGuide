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
