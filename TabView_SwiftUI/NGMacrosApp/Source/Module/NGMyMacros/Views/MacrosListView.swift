//
//  MacrosListView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct MacrosListView: View {
    
    // MARK: Private properties
    private var viewModel: MacrosListViewModel
    
    // MARK: Initilizer
    init(viewModel: MacrosListViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            VStack {
                if let currentTab = self.viewModel.currentTab,
                   let searchMacroModelArray = self.viewModel.modelDataArray,
                   !searchMacroModelArray.isEmpty,
                   let currentTab = TabBarSelected(rawValue: currentTab) {
                    switch currentTab {
                    case.myMacro:
                        let searchMacroDataArray = searchMacroModelArray as? [MacrosModel] ?? []
                        ForEach(searchMacroDataArray, id: \.id) { macrosModel in
                            self.macroModelListScroll(macrosModel: macrosModel,
                                                      currentTab: currentTab.rawValue)
                        }
                    case .posts:
                        let searchPostDataArray = self.viewModel.modelDataArray as? [PostsModel] ?? []
                        ForEach(searchPostDataArray, id: \.id) { macrosModel in
                            self.macroModelListScroll(macrosModel: macrosModel,
                                                      currentTab: currentTab.rawValue)
                        }
                    case .clinicMacros:
                        showNotFoundDataView
                    }
                } else {
                    showNotFoundDataView
                }
            }
        }
        .background(Color(.clear))
    }
    
    // MARK: Scroll List not found view
    private var showNotFoundDataView: some View {
        HStack {
            Spacer().frame(height: 12)
            Text(MacrosConstant.noRecordFound)
                .lineLimit(1)
                .padding(.trailing, 10)
                .font(Font.system(size: 15))
            Spacer().frame(height: 4)
        }
    }
    
    // MARK: macro Model List Scroll
    func macroModelListScroll(macrosModel: Any?,
                              currentTab: Int) -> some View {
        LazyVStack {
            MacrosRowView(model: MacrosRowViewModel(model: macrosModel,
                                                    currentTab: currentTab,
                                                    editOptionTapped: { model, enumOperationType in
                self.viewModel.onDeleteButtonTapped(model, enumOperationType)
            }))
        }
    }
}

struct MacrosListView_Previews: PreviewProvider {
    static var previews: some View {
        let macroModel = MacrosListViewModel(currentTab: 0,
                                             modelDataArray: [MacrosModel(gender: "M",
                                                                          name: Name(title: "",
                                                                                     first: "",
                                                                                     last: ""),
                                                                          location: Location(street: Street(number: 0,
                                                                                                            name: ""),
                                                                                             city: "",
                                                                                             state: "",
                                                                                             country: ""),
                                                                          email: "",
                                                                          phone: "",
                                                                          cell: "",
                                                                          nat: "")], editOptionTapped: {_, _ in })
        MacrosListView(viewModel: macroModel)
    }
}
