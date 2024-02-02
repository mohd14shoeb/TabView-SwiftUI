//
//  TabBarView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 08/08/23.
//

import SwiftUI

struct TabBarView: View {
    // MARK: Private properties
    @Binding private var currentTab: Int
    private var model: TabBarItemModel
    private let namespace: Namespace.ID

    // MARK: Initilizer
    init(currentTab: Binding<Int>,
         model: TabBarItemModel,
         namespace: Namespace.ID) {
        self._currentTab = currentTab
        self.model = model
        self.namespace = namespace
    }

    // MARK: Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(Array(zip(self.model.tabBarArray.indices,
                                  self.model.tabBarArray)),
                        id: \.0,
                        content: {  index, name in
                    TabBarItemView(currentTab: self.$currentTab,
                                   model: self.model,
                                   tabBarItemName: name,
                                   tabIndex: index, namespace: self.namespace)
                })

            }
            .padding(.horizontal, 0)
            .background(Color.clear)
             .frame(height: 30)
        }
    }
}

// MARK: TabBarView Previews
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        let model = TabBarItemModel(selectedItemColor: .blue,
                                    unselectedItemColor: .black,
                                    tabBarOptions: ["First", "Second"])
        TabBarView(currentTab: .constant(0), model: model, namespace: namespace)
    }
}
