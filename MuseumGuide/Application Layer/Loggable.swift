//
//  Loggable.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

public enum LogTag: String {
    case unnamed
    case observable
    case model
    case viewModel
    case view
    case service
    case presenter
    case viewController
}

public enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
}

public protocol Loggable {
    var defaultLoggingTag: LogTag { get }

    func log(_ level: LogLevel, _ message: String)
    func log(_ level: LogLevel, tag: LogTag, _ message: String)
}

public extension Loggable {
    func log(_ level: LogLevel, _ message: String) {
        self.log(level, tag: defaultLoggingTag, message)
    }

    func log(_ level: LogLevel, tag: LogTag, _ message: String) {
        print("\([tag.rawValue]) - \(message)")
    }
}
