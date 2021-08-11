//
//  ParentView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct ParentView: View {
    var store: Store<Parent.State, Parent.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                List {
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
                    .padding(.bottom, 32)

                    ForEachStore(self.store.scope(state: \.childModels, action: Parent.Action.child(id:action:)), content: ChildCard.init(store:))
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
            .navigationBarItems(trailing: Button { viewStore.send(.fetch)} label: { Text("Fetch") })
        }
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView(store: Parent.previewStore)
    }
}
