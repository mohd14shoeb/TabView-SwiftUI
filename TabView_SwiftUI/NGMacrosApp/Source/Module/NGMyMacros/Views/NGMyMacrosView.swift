//
//  NGMyMacrosView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 08/08/23.
//

import SwiftUI

struct NGMyMacrosView: View {

    // MARK: Private properties
    @Namespace private var namespace
    @ObservedObject private var viewModel: MacrosViewModel
    @StateObject private var undoRedoViewModel = UndoRedoViewModel()

    // MARK: Initilizer
    init(model: MacrosViewModel) {
        self.viewModel = model
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color.screenBackgroundColor
                    .ignoresSafeArea()
                VStack {
                    Spacer(minLength: 8)
                    containerSubView
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.white)
                                .ignoresSafeArea(edges: .bottom))
                }
                progressCircleView
            }
            .navigationDestination(isPresented: self.$viewModel.showNextScreenView) {
                AddMacrosView(isKeyboardFocused: false,
                              undoRedoViewModel: undoRedoViewModel,
                              viewModel: self.viewModel).navigationBarHidden(true)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                navigationToolBarView()
            }.onAppear {
                if !self.viewModel.showNextScreenView {
                     self.viewModel.getMacrosModelResponse()
                }
            }
            .alert(isPresented: self.$viewModel.showsAlert) {
                Alert(title: Text(self.viewModel.alertErrorMessage ?? MacrosConstant.noRecordFound))
            }
        }.disabled(viewModel.isLoadingShowing ? true : false)
    }

    // MARK: Screen container SubView
    private var containerSubView: some View {
        VStack(alignment: .center, spacing: -1) {
            SearchBar(text: self.$viewModel.searchText)
                .padding(.horizontal, 2)
            Spacer().frame(height: 30)
            TabBarView(currentTab: self.$viewModel.currentTab,
                       model: self.viewModel.model,
                       namespace: namespace.self)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(Color.clear)
            Divider()
                .frame(height: 1)
                .background(Color.gray).opacity(0.3)
            Spacer().frame(height: 10)
            macrosScrollListRow
            Spacer()
        }
        .padding(.top, 20)
    }

    // MARK: ScrollListRow
    private var macrosScrollListRow: some View {
        VStack {
            let searchModelArray = self.viewModel.searchDataModel(searchText: self.viewModel.searchText,
                                                                  currentTabIndex: viewModel.currentTab)
            MacrosListView(viewModel: MacrosListViewModel(currentTab: viewModel.currentTab,
                                                          modelDataArray: searchModelArray,
                                                          editOptionTapped: { model, enumOperationType in
                switch enumOperationType {
                case.edit:
                    self.viewModel.macrosModel = model
                    self.viewModel.showNextScreenView = true
                case .delete:
                    self.viewModel.deleteModelData(macrosModel: model,
                                                   tabIndex: self.viewModel.currentTab)
                }
            }))
        }
    }

    // MARK: progressCircleView Indicator
    private var progressCircleView: some View {
        VStack {
            if viewModel.isLoadingShowing {
                ProgressCircleView()
                    .position(x: UIScreen.main.bounds.width/2,
                              y: UIScreen.main.bounds.height/2)
                    .zIndex(1)
            }
        }
    }

    // MARK: Toolbar Content Builder
    @ToolbarContentBuilder
    private func navigationToolBarView() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                // viewModel.dismissView()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.backward")
                }
                .foregroundColor(.white)
                .font(.system(size: 16))
            }
            .foregroundColor(.white)
            .font(.system(size: 16))
        }
        ToolbarItem(placement: .principal) {
            Text(MacrosConstant.myMacroNavigationTitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                to: nil, from: nil, for: nil)
                self.viewModel.clearEditModifyData()
                self.viewModel.showNextScreenView = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .resizable().frame(width: 14, height: 14)
                    Text("Add New")
                }
                .foregroundColor(.white)
                .font(.system(size: 16))
            }
        }
    }
}

// MARK: TabBarView Previews
struct NGMyMacrosView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        let model = TabBarItemModel(selectedItemColor: .screenBackgroundColor,
                                    unselectedItemColor: .black,
                                    tabBarOptions: ["First", "Second"])
        let viewModel = MacrosViewModel(model: model, networkManager: MacrosServiceManager())
        NGMyMacrosView(model: viewModel)
    }
}
