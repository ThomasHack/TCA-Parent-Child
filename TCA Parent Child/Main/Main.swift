//
//  Root.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Main {
    struct State: Equatable {
        var models: IdentifiedArrayOf<Parent.State> = []
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
        case reset
        case shared(Shared.Action)
        case api(Api.Action)
        case parent(id: Parent.State.ID, action: Parent.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
    }

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )

    static let reducer = Reducer<State, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .fetch:
                return Effect(value: .api(.fetchModels))

            case .reset:
                state.models = []

            case .api(.fetchModelsResponse(let models)):
                state.models = []
                models.forEach { model in
                    state.models.append(
                        Parent.State(model: model, shared: Shared.initialState, api: Api.initialState)
                    )
                }
            case .parent, .shared, .api:
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
        Parent.reducer.forEach(
            state: \.models,
            action: /Main.Action.parent(id:action:),
            environment: { $0 }
        )
    )

    static let store = Store(
        initialState: State(shared: Shared.initialState, api: Api.initialState),
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )

    static let initialState = State(shared: Shared.initialState, api: Api.initialState)

    static let previewState = State(
        models: [
            .init(model: Mock.models.first, shared: Shared.initialState, api: Api.initialState)
        ],
        shared: Shared.initialState,
        api: Api.initialState
    )

    static let previewStore = Store(
        initialState: Main.previewState,
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )
}
