//
//  ParentCard.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct ParentCard: View {
    var store: Store<Parent.State, Parent.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationLink(destination: ParentView(store: store)) {
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

struct ParentCard_Previews: PreviewProvider {
    static var previews: some View {
        ParentCard(store: Parent.previewStore)
    }
}
