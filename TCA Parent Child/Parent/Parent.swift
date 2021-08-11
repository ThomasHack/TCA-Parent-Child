//
//  Parent.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Parent {
    struct State: Identifiable, Equatable {
        let id = UUID()
        var model: Model?
        var childModels: IdentifiedArrayOf<Child.State> = []

        var shared: Shared.State
        var api: Api.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Api.State, T>) -> T {
            get { api[keyPath: keyPath] }
            set { api[keyPath: keyPath] = newValue }
        }
    }

    enum Action {
        case fetch
        case increment
        case decrement
        case child(id: Child.State.ID, action: Child.Action)
        case shared(Shared.Action)
        case api(Api.Action)
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .fetch:
                guard let model = state.model else { return .none }
                return Effect(value: .api(.fetchChildModels(model: model.name)))

            case .increment:
                state.model?.value += 1

            case .decrement:
                state.model?.value -= 1

            case let .api(.fetchChildModelsResponse(modelName, childModels)):
                state.childModels = []
                childModels.forEach { childModel in
                    state.childModels.append(
                        Child.State(model: childModel, shared: state.shared)
                    )
                }

            case .child, .shared, .api:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Api.reducer.pullback(
            state: \.api,
            action: /Action.api,
            environment: { $0 }
        ),
        Child.reducer.forEach(
            state: \.childModels,
            action: /Parent.Action.child(id:action:),
            environment: { $0 }
        )
    )

    static let initialState = State(shared: Shared.initialState, api: Api.initialState)

    static let previewState = State(
        model: Mock.models.first,
        childModels: .init(arrayLiteral: Child.State(model: Mock.generateChildren(parent: Mock.models.first!.name).first, shared: Shared.previewState)),
        shared: Shared.initialState,
        api: Api.initialState
    )

    static let previewStore = Store(
        initialState: Parent.previewState,
        reducer: Parent.reducer,
        environment: Main.initialEnvironment
    )
}
