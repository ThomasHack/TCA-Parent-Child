//
//  Child.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Child {
    struct State: Identifiable, Equatable {
        let id = UUID()
        var model: ChildModel?
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }

    enum Action {
        case increment
        case decrement
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .increment:
                state.model?.value += 1

            case .decrement:
                state.model?.value -= 1

            case .shared:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \.shared,
            action: /Action.shared,
            environment: { $0 }
        )
    )

    static let initialState = State(shared: Shared.initialState)

    static let previewState = State(model: ChildModel(name: "Child Model", value: 0), shared: Shared.initialState)

    static let previewStore = Store(
        initialState: Child.previewState,
        reducer: Child.reducer,
        environment: Main.initialEnvironment
    )
}
