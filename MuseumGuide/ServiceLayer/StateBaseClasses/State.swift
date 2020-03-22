//
//  State.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

protocol State: Equatable {
    associatedtype Event
    associatedtype Effect
    mutating func handle(event: Event) -> Effect?
    static var initialState: Self { get }
}

