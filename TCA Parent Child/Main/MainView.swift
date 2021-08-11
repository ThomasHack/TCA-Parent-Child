//
//  RootView.swift
//  
//
//

import ComposableArchitecture
import SwiftUI

struct MainView: View {
    var store: Store<Main.State, Main.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEachStore(self.store.scope(state: \.models, action: Main.Action.parent(id:action:)), content: ParentCard.init(store:))
                Spacer()

                HStack {
                    Text("Shared")
                        .font(.headline)
                    Spacer()
                    HStack {
                        Button { viewStore.send(.shared(.decrement)) } label: { Text("-") }
                            .foregroundColor(Color.secondary)
                            .buttonStyle(PlainButtonStyle())
                        Text("\(viewStore.shared.value)")
                            .frame(minWidth: 24)
                        Button { viewStore.send(.shared(.increment)) } label: { Text("+") }
                            .foregroundColor(Color.secondary)
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
            .navigationBarItems(trailing: HStack {
                Button { viewStore.send(.reset) } label: { Text("Reset") }
                Button { viewStore.send(.fetch) } label: { Text("Fetch") }
            })
            .navigationBarTitle(Text("Root"), displayMode: .large)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(store: Main.previewStore)
    }
}
