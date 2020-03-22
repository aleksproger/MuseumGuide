//
//  EventSource.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

//MARK: - Base Event Source Protocol

protocol EventSource: class {
    associatedtype S: State
    func configureEventSource(dispatch: @escaping Closure<S.Event>)
}

//MARK: - Type Erasing

fileprivate class _AnyEventSourceBox<S: State>: EventSource {
    
    @available(*, unavailable)
    init() {}
    
    func configureEventSource(dispatch: @escaping Closure<S.Event>) {
        fatalError()
    }
}

fileprivate class _EventSourceBox<Base: EventSource>: _AnyEventSourceBox<Base.S> {
    private let _base: Base
    
    init(_ eventSource: Base) {
        _base = eventSource
    }
    
    override func configureEventSource(dispatch: @escaping Closure<Base.S.Event>) {
        _base.configureEventSource(dispatch: dispatch)
    }
}

//MARK: - Type Erased Wrapper

class AnyEventSource<S: State>: EventSource {
    private let _box: _AnyEventSourceBox<S>
    
    init<ES: EventSource>(_ eventSource: ES) where ES.S == S {
        _box = _EventSourceBox(eventSource)
    }
    
    func configureEventSource(dispatch: @escaping (S.Event) -> Void) {
        _box.configureEventSource(dispatch: dispatch)
    }
}

class LocationEvents: EventSource {
    typealias S = LocationState
    //private let store: Store<LocationState, Error>
    
    init() {
        //self.store = store
    }
    
    func configureEventSource(dispatch: @escaping Closure<LocationState.Event>) {
        //store.statePublisher
    }
}
