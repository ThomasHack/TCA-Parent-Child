//
//  ChildView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct ChildView: View {
    var store: Store<Child.ChildFeature, Child.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    Text(viewStore.model?.name ?? "-")
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button { viewStore.send(.decrement) } label: { Text("-") }
                            .foregroundColor(Color.secondary)
                        Text("\(viewStore.model?.value ?? -1)")
                            .frame(minWidth: 24)
                        Button { viewStore.send(.increment) } label: { Text("+") }
                            .foregroundColor(Color.secondary)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                }
                Spacer()

                HStack {
                    Text("Shared")
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button { viewStore.send(.shared(.decrement)) } label: { Text("-") }
                            .foregroundColor(Color.secondary)
                        Text("\(viewStore.shared.value)")
                            .frame(minWidth: 24)
                        Button { viewStore.send(.shared(.increment)) } label: { Text("+") }
                            .foregroundColor(Color.secondary)
                    }
                }
            }
            .padding()
            .navigationTitle(viewStore.model?.name ?? "-")
        }
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(store: Child.previewStore)
    }
}
