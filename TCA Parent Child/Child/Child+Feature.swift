//
//  Root+Feature.swift
//
//
//

import Foundation

extension Child {
    @dynamicMemberLookup

    struct ChildFeature: Identifiable, Equatable {
        let id: UUID
        var child: Child.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Child.State, T>) -> T {
            get { child[keyPath: keyPath] }
            set { child[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }
}
