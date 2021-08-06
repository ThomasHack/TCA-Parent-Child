//
//  File.swift
//
//
//

import Foundation

struct ChildModel: Equatable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var value: Int
}

struct Model: Equatable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var value: Int
}

enum Mock {
    static let models = [
        Model(id: UUID(), name: "Model 1", value: 0),
        Model(id: UUID(), name: "Model 2", value: 0),
        Model(id: UUID(), name: "Model 3", value: 0)
    ]

    static let childModels: [String: [ChildModel]] = [
        "Model 1": generateChildren(parent: "Model 1"),
        "Model 2": generateChildren(parent: "Model 2"),
        "Model 3": generateChildren(parent: "Model 3"),
    ]

    static func generateChildren(parent: String) -> [ChildModel] {
        [
            ChildModel(id: UUID(), name: "\(parent) - Child 1", value: 0),
            ChildModel(id: UUID(), name: "\(parent) - Child 2", value: 0),
            ChildModel(id: UUID(), name: "\(parent) - Child 3", value: 0),
            ChildModel(id: UUID(), name: "\(parent) - Child 4", value: 0),
            ChildModel(id: UUID(), name: "\(parent) - Child 5", value: 0)
        ]
    }
}
