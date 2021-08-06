//
//  RootView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    var store: Store<Main.MainFeature, Main.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                ForEachStore(self.store.scope(state: \.models, action: Main.Action.parent(id:action:))) { parentStore in
                    WithViewStore(parentStore) { parentViewStore in
                        HStack {
                            NavigationLink {
                                ParentView(store: parentStore)
                            } label: {
                                    Text(parentViewStore.model?.name ?? "-")
                                        .font(.headline)
                            }
                            Spacer()
                            HStack {
                                Button { parentViewStore.send(.decrement) } label: { Text("-") }
                                    .foregroundColor(Color.secondary)
                                Text("\(parentViewStore.model?.value ?? -1)")
                                    .frame(minWidth: 24)
                                Button { parentViewStore.send(.increment) } label: { Text("+") }
                                    .foregroundColor(Color.secondary)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(15)
                        }
                    }
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
            .navigationBarItems(trailing: Button { viewStore.send(.fetch) } label: { Text("Fetch") })
            .navigationBarTitle(Text("Root"), displayMode: .large)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.previewStore)
    }
}
