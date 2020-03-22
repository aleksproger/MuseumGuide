//
//  EffectHandler.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

//MARK: - Base Event Source Protocol

protocol EffectHandler {
    associatedtype S: State
    associatedtype E: Error
    func handle(_ effect: S.Effect) -> Future<S.Event, E>?
}

//MARK: - Type Erasing

fileprivate class _AnyEffectHandlerBox<S: State, E: Error>: EffectHandler {
    
    @available(*, unavailable)
    init() {}

    func handle(_ effect: S.Effect) -> Future<S.Event, E>? {
        fatalError("Method has to be overriden this is an abstract class")
    }
}

fileprivate class _EffectHandlerBox<Base: EffectHandler>: _AnyEffectHandlerBox<Base.S, Base.E> {
    private let _base: Base
    
    init(_ base: Base) {
        _base = base
    }
    
    override func handle(_ effect: S.Effect) -> Future<S.Event, E>? {
        return _base.handle(effect)
    }
}

//MARK: - Type Erased Wrapper

struct AnyEffectHandler<S: State, E: Error>: EffectHandler {
    private let _box: _AnyEffectHandlerBox<S, E>
    
    init<EH: EffectHandler>(_ effectHandler: EH) where EH.S == S, EH.E == E {
        _box = _EffectHandlerBox(effectHandler)
    }
    
    func handle(_ effect: S.Effect) -> Future<S.Event, E>? {
        return _box.handle(effect)
    }
}
