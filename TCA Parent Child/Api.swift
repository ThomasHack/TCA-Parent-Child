//
//  Api.swift
//  
//
//

import ComposableArchitecture
import Foundation

enum Api {
    struct State: Equatable {
        var models: [Model] = []
        var childModels: [String: [ChildModel]] = [:]
    }

    enum Action {
        case fetchModels
        case fetchModelsResponse([Model])
        case fetchChildModels(model: String)
        case fetchChildModelsResponse(modelName: String, childModels: [ChildModel])
    }

    typealias Environment = Main.Environment

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .fetchModels:
            let models = Mock.models
            return Effect(value: .fetchModelsResponse(models))

        case .fetchModelsResponse(let models):
            state.models = models

        case let .fetchChildModels(modelName):
            let childModels = Mock.generateChildren(parent: modelName)
            return Effect(value: .fetchChildModelsResponse(modelName: modelName, childModels: childModels))

        case let .fetchChildModelsResponse(modelName, childModels):
            state.childModels[modelName] = childModels
        }
        return .none
    }

    static let initialState = State()

    static let previewState = State()

    static let previewStore = Store(
        initialState: Api.previewState,
        reducer: Api.reducer,
        environment: Main.initialEnvironment
    )
}
