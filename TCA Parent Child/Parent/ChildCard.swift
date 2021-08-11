//
//  ParentCard.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct ChildCard: View {
    var store: Store<Child.State, Child.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationLink(destination: ChildView(store: store)) {
                HStack {
                    Text(viewStore.model?.name ?? "-")
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button { viewStore.send(.decrement) } label: { Text("-") }
                            .foregroundColor(Color.secondary)
                            .buttonStyle(PlainButtonStyle())
                        Text("\(viewStore.model?.value ?? -1)")
                            .frame(minWidth: 24)
                        Button { viewStore.send(.increment) } label: { Text("+") }
                            .foregroundColor(Color.secondary)
                            .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                }
            }
        }
    }
}

struct ChildCard_Previews: PreviewProvider {
    static var previews: some View {
        ChildCard(store: Child.previewStore)
    }
}
