//
//  AddMacrosView.swift
//  NGMacrosApp
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct AddMacrosView: View {

    // MARK: Private properties
    @Environment(\.presentationMode)
    private var mode: Binding<PresentationMode>
    @FocusState private var isKeyboardFocused: Bool
    @ObservedObject private var undoRedoViewModel: UndoRedoViewModel
    @ObservedObject private var viewModel: MacrosViewModel
   
    // MARK: Initilizer
    init(isKeyboardFocused: Bool,
         undoRedoViewModel: UndoRedoViewModel,
         viewModel: MacrosViewModel) {
        self.undoRedoViewModel = undoRedoViewModel
        self.viewModel = viewModel
    }

    // MARK: Body
    var body: some View {
        NavigationView {
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
                                .foregroundColor(.containerBackgroundColor)
                                .ignoresSafeArea(edges: .bottom)
                        )
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                navigationToolBarView()
            }.onAppear {
                self.viewModel.getMacroPropertyValue()
                self.undoRedoViewModel.getMacroModelPropertyValue(macrosModel: viewModel.macrosModel,
                                                                  currentTab: viewModel.currentTab)
            }
        }
    }

    // MARK: Add Macros Screen container SubView
    private var containerSubView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 2) {
                textFieldSubView
                Spacer().frame(height: 14)
                UndoRedoTextEditor(viewModel: undoRedoViewModel,
                                   isKeyboardFocused: isKeyboardFocused).onTapGesture {
                    isKeyboardFocused = true
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 34)
        }
    }

    // MARK: text Field SubView
    private var textFieldSubView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(MacrosConstant.macroNameText)
                .font(.system(size: 14))
            Spacer().frame(height: 4)
            TextField(MacrosConstant.textFieldPlaceholder,
                      text: self.$viewModel.macroName)
                .autocorrectionDisabled(true)
                .font(.system(size: 17))
                .padding(12)
                .padding(.horizontal, 4)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.4),
                                lineWidth: 0.5)
                ) .padding(EdgeInsets(top: 0, leading: 0.0,
                                      bottom: 0, trailing: 0))
        }
    }

    // MARK: Toolbar ContentBuilder
    @ToolbarContentBuilder
    private func navigationToolBarView() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Back") {
                self.viewModel.clearEditModifyData()
                self.undoRedoViewModel.clearAllText()
                self.mode.wrappedValue.dismiss()
            }
            .foregroundColor(.white)
            .font(.system(size: 16))
        }
        ToolbarItem(placement: .principal) {
            Text(MacrosConstant.addMacroNavigationTitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                    viewModel.updateModelData(macrosModel: self.viewModel.macrosModel,
                                              tabIndex: viewModel.currentTab,
                                              newCategory: self.viewModel.macroName,
                                              newDescription: undoRedoViewModel.editText)
                self.viewModel.clearEditModifyData()
                self.undoRedoViewModel.clearAllText()
                    self.mode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark")
                        .resizable().frame(width: 14, height: 12)
                        Text("Done")
                        .font(.system(size: 16))
                }
                    .disabled(self.doneBUttonDisable())
                        .foregroundColor(.white.opacity(self.doneBUttonDisable() ? 0.4 : 1))
                        .font(.system(size: 16))
            }
        }
    }

    // MARK: done BUtton Disable
    func doneBUttonDisable() -> Bool {
        if  self.viewModel.macroName.isEmpty || undoRedoViewModel.editText.isEmpty {
            return true
        }
        return false
    }
}

struct AddMacrosView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var namespace
        let model = TabBarItemModel(selectedItemColor: .screenBackgroundColor,
                                    unselectedItemColor: .black,
                                    tabBarOptions: ["First", "Second"])
        let viewModel = MacrosViewModel(model: model,
                                        networkManager: MacrosServiceManager())
       let undo =  UndoRedoViewModel()
        AddMacrosView(isKeyboardFocused: true,
                      undoRedoViewModel: undo,
                      viewModel: viewModel)
    }
}
