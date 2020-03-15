//
//  ViewControllerEventHandler.swift
//  MuseumGuide
//
//  Created by Alex on 15.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

public protocol ViewControllerEventHandler: class {
    func didLoad()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
    func willClose()
}

extension ViewControllerEventHandler {
    public func didLoad() {}
    public func willAppear() {}
    public func didAppear() {}
    public func willDisappear() {}
    public func didDisappear() {}
    public func willClose() {}
}
