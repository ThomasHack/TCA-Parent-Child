//
//  Root.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Main {
    struct State: Equatable {
        var models: IdentifiedArrayOf<Parent.ParentFeature> = []
    }

    enum Action {
        case fetch
        case shared(Shared.Action)
        case parent(id: Parent.ParentFeature.ID, action: Parent.Action)
    }

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
    }

    static let initialEnvironment = Environment(
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )

    static let reducer = Reducer<MainFeature, Action, Environment>.combine(
        Reducer { state, action, _ in
            switch action {
            case .fetch:
                state.models = []
                Mock.models.forEach { model in
                    state.models.append(
                        Parent.ParentFeature(id: UUID(), parent: Parent.State(model: model), shared: state.shared)
                    )
                }

            case .parent, .shared:
                break
            }
            return .none
        },
        Shared.reducer.pullback(
            state: \.shared,
            action: /Action.shared,
            environment: { $0 }
        ),
        Parent.reducer.forEach(
            state: \.models,
            action: /Main.Action.parent(id:action:),
            environment: { $0 }
        )
    )

    static let store = Store(
        initialState: Main.MainFeature(main: Main.initialState, shared: Shared.initialState),
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )

    static let initialState = State()

    static let previewState = MainFeature(
        main: Main.State(models: [
            .init(id: UUID(), parent: Parent.State(model: Model(id: UUID(), name: "Model 1", value: 0)), shared: Shared.initialState)
        ]),
        shared: Shared.initialState)

    static let previewStore = Store(
        initialState: Main.previewState,
        reducer: Main.reducer,
        environment: Main.initialEnvironment
    )
}
