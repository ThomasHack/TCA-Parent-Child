//
//  Parent.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Parent {
    struct State: Equatable {
        var model: Model?
        var childModels: IdentifiedArrayOf<Child.ChildFeature> = []
    }

    enum Action {
        case fetch
        case increment
        case decrement
        case shared(Shared.Action)
        case child(id: Child.ChildFeature.ID, action: Child.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<ParentFeature, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .fetch:
                guard let model = state.model, let childModels = Mock.childModels[model.name] else { return .none }
                state.childModels = []
                childModels.forEach { childModel in
                    state.childModels.append(
                        Child.ChildFeature(id: UUID(), child: Child.State(model: childModel), shared: state.shared)
                    )
                }

            case .increment:
                state.model?.value += 1

            case .decrement:
                state.model?.value -= 1

            case .child, .shared:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Child.reducer.forEach(
            state: \.childModels,
            action: /Parent.Action.child(id:action:),
            environment: { $0 }
        )
    )

    static let initialState = State()

    static let previewState = ParentFeature(id: UUID(), parent: Parent.initialState, shared: Shared.initialState)

    static let previewStore = Store(
        initialState: Parent.previewState,
        reducer: Parent.reducer,
        environment: Main.initialEnvironment
    )
}
