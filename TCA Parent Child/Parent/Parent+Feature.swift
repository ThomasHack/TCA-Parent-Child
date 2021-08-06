//
//  Root+Feature.swift
//
//
//

import Foundation

extension Parent {
    @dynamicMemberLookup

    struct ParentFeature: Identifiable, Equatable {
        let id: UUID
        var parent: Parent.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Parent.State, T>) -> T {
            get { parent[keyPath: keyPath] }
            set { parent[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }
}
