//
//  ServiceHandler.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol Handler: class {
    associatedtype T
    func handle(request: ServiceRequest<T>) -> Result<Any, Error>
}

//class ServiceHandler<T>: Handler {
//    func handle<T>(request: ServiceRequest<T>) -> Result<Any, Error> {
//        switch request {
//        case .locationRequest:
//            print()
//        }
//    }
//}
