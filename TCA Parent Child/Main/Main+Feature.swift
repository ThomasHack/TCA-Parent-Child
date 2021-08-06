//
//  Root+Feature.swift
//
//
//

import Foundation

extension Main {
    @dynamicMemberLookup

    struct MainFeature: Equatable {
        var main: Main.State
        var shared: Shared.State

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Main.State, T>) -> T {
            get { main[keyPath: keyPath] }
            set { main[keyPath: keyPath] = newValue }
        }

        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Shared.State, T>) -> T {
            get { shared[keyPath: keyPath] }
            set { shared[keyPath: keyPath] = newValue }
        }
    }
}
