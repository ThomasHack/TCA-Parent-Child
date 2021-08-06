//
//  Shared.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Shared {
    struct State: Equatable {
        var value = 0
    }

    enum Action {
        case increment
        case decrement
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .increment:
            state.value += 1
        case .decrement:
            state.value -= 1
        }
        return .none
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Shared.previewState,
        reducer: Shared.reducer,
        environment: Main.initialEnvironment
    )
}
