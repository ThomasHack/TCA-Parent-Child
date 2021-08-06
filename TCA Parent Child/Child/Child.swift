//
//  Child.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Child {
    struct State: Equatable {
        var model: ChildModel?
    }

    enum Action {
        case increment
        case decrement
        case shared(Shared.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<ChildFeature, Action, Environment>.combine(
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

    static let initialState = State()

    static let previewState = ChildFeature(id: UUID(), child: Child.State(model: ChildModel(id: UUID(), name: "Child Model", value: 0)), shared: Shared.initialState)

    static let previewStore = Store(
        initialState: Child.previewState,
        reducer: Child.reducer,
        environment: Main.initialEnvironment
    )
}
