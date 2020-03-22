//
//  ViewState.swift
//  MuseumGuide
//
//  Created by Alex on 22.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

protocol ViewState {
    
}

protocol StatefulView {
    associatedtype State: ViewState
    func render(state: State)
    //var renderPolicy: RenderPolicy { get }
}

public enum RenderPolicy {
    case possible
    case notPossible(RenderError)

    public enum RenderError {
        case viewNotReady
        case viewDeallocated
    }
}

//MARK: - Type Erasing

fileprivate class _AnyStatefulViewBox<State: ViewState>: StatefulView {
    @available(*, unavailable)
    init() {}

    func render(state: State) {
        fatalError()
    }


}

fileprivate class _StatefulViewBox<Base: StatefulView>: _AnyStatefulViewBox<Base.State> {
    private let _base: Base

    init(_ base: Base) {
        _base = base
    }

    override func render(state: Base.State){
        return _base.render(state: state)
    }
}

//MARK: - Type Erased Wrapper

struct AnyStatefulView<State: ViewState>: StatefulView {
    private let _box: _AnyStatefulViewBox<State>

    init<SV: StatefulView>(_  statefulView: SV) where SV.State == State {
        _box = _StatefulViewBox(statefulView)
    }

    func render(state: State){
        return _box.render(state: state)
    }
}
