//
//  TabBarItemView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 08/08/23.
//

import SwiftUI

struct TabBarItemView: View {

    // MARK: Private properties
    @Binding private var currentTab: Int
    private let model: TabBarItemModel
    private let tabBarItemName: String
    private let tabIndex: Int
    private let namespace: Namespace.ID

    // MARK: Initilizer
    init(currentTab: Binding<Int>,
         model: TabBarItemModel,
         tabBarItemName: String,
         tabIndex: Int,
         namespace: Namespace.ID) {
        self._currentTab = currentTab
        self.model = model
        self.tabBarItemName = tabBarItemName
        self.tabIndex = tabIndex
        self.namespace = namespace
    }

    // MARK: Body
    var body: some View {
        Button {
            self.currentTab = self.tabIndex
        } label: {
            VStack {
                Spacer()
                let title = Text(self.tabBarItemName).padding([.leading, .trailing], 10)
                    .font(Font.system(size: 14))

                if currentTab == self.tabIndex {
                    title.foregroundColor(self.model.selecteTabColor)
                    self.model.selecteTabColor
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: self.namespace,
                                               properties: .frame)
                } else {
                    title.foregroundColor(self.model.unSelecteTabColor)
                    Color.clear.frame(height: 2)
                }
                Spacer()
            }
            .animation(.spring(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}

// MARK: TabBarItemView Previews
struct TabBarItemView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        let model = TabBarItemModel(selectedItemColor: .blue,
                                    unselectedItemColor: .black,
                                    tabBarOptions: ["First", "Second"])
        TabBarItemView(currentTab: .constant(0),
                       model: model,
                       tabBarItemName: "First",
                       tabIndex: 0, namespace: namespace)
    }
}
