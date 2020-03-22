//
//  Store.swift
//  MuseumGuide
//
//  Created by Alex on 21.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

final class Store<S: State, E: Error>: Loggable {
    private let effectHandler: AnyEffectHandler<S, E>
    private let eventSource: AnyEventSource<S>
    private lazy var stateTransactionQueue = DispatchQueue(label: "com.Alex.MuseumGuide\(type(of: self)).TransactionQueue")
    private var subscriptions = Set<AnyCancellable>()
    private let _statePublisher: CurrentValueSubject<S, Never>
    
    var defaultLoggingTag: LogTag { .store }
    
    var state: S {
        didSet(oldState) {
            //dispatchPrecondition(condition: .onQueue(stateTransactionQueue))
            stateDidChange(oldState: oldState, newState: state)
        }
    }
    
    var statePublisher: AnyPublisher<S, Never> {
        return _statePublisher.eraseToAnyPublisher()
    }
    
    init<EH: EffectHandler, ES: EventSource>(effectHandler: EH, eventSource: ES, initialState: S) where EH.S == S, EH.E == E, ES.S == S {
        self.state = initialState
        self.effectHandler = AnyEffectHandler<EH.S, EH.E>(effectHandler)
        self.eventSource = AnyEventSource<EH.S>(eventSource)
        self._statePublisher = CurrentValueSubject<S, Never>(state)
        self.eventSource.configureEventSource { [weak self] in
            self?.dispatch(event: $0)
        }
    }
    
    @discardableResult
    func dispatch(event: S.Event) -> Future<S, Never> {
        let effect = state.handle(event: event)
        let effectFuture = effect.flatMap {
            effectHandler.handle($0)
        }
        let currentStateFuture = Future<S, Never> { [weak self] promise in
            guard let self = self else { return }
            promise(.success(self.state))
        }
        
        _ = effectFuture.flatMap {
            $0.sink(receiveCompletion: { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    self?.log(.debug, error.localizedDescription)
                default:
                    break
                }
                }, receiveValue: { self.dispatch(event: $0) })
            }?.store(in: &subscriptions)
        return currentStateFuture
        
    }
    
    private func stateDidChange(oldState: S, newState: S) {
        guard oldState != newState else {
            log(.debug, "Skip the same state \(newState)")
            return
        }
        log(.debug, "State change from \(oldState) to \(newState)")
        _statePublisher.send(newState)
    }
}
