//
//  UndoRedoTextEditor.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 11/08/23.
//

import SwiftUI

struct UndoRedoTextEditor: View {

    // MARK: Private properties
    @FocusState private var isKeyboardFocused: Bool
    @ObservedObject private var viewModel: UndoRedoViewModel

    // MARK: Initilizer
    init(viewModel: UndoRedoViewModel, isKeyboardFocused: Bool) {
        self.viewModel = viewModel
         self.isKeyboardFocused = isKeyboardFocused

    }

    // MARK: Body
    var body: some View {
        VStack(alignment: .trailing) {
            undoTypeSubView
        }
    }

    // MARK: undo redo SubView
    private var undoTypeSubView: some View {
        VStack(alignment: .trailing, spacing: 8) {
            HStack(spacing: 10) {
                Button(action: self.viewModel.undoType) {
                    Image(systemName: "arrow.uturn.backward")

                }.padding(.all, 6)
                    .cornerRadius(6)
                    .background(.white.opacity(self.viewModel.editText.isEmpty ? 0.5 : 1))
                    .disabled(self.viewModel.editText.isEmpty)
                Button(action: self.viewModel.redoType) {
                    Image(systemName: "arrow.uturn.forward")

                }
                .cornerRadius(8)
                .padding(.all, 6)
                .background(.white.opacity(self.viewModel.undoText.isEmpty ? 0.5 : 1))
                .disabled(self.viewModel.undoText.isEmpty)
            }
            .foregroundColor(.gray)
            .padding(EdgeInsets(top: 0,
                                leading: 0.0,
                                bottom: 0,
                                trailing: 5))
            textEditorSubView
        }
    }

    // MARK: textEditor SubView
    private var textEditorSubView: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: self.$viewModel.editText)
                .autocorrectionDisabled(true)
                 .focused($isKeyboardFocused)
                .frame(height: 260)
                .foregroundColor(.black)
                .font(.system(size: 14))
                .padding(10)
                .scrollContentBackground(.visible)
                .accentColor(.blue)
                .multilineTextAlignment(.leading)
                .background(.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray.opacity(0.4), lineWidth: 0.3)
                ) .padding(EdgeInsets(top: 3, leading: 0.0,
                                      bottom: 0, trailing: 0))

                if self.viewModel.editText.isEmpty {
                    Text(MacrosConstant.textEditorPlaceholder)
                        .autocorrectionDisabled(true)
                        .focused($isKeyboardFocused)
                        .disabled(true)
                        .opacity(0.5)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 18)
                }
            }
        }
    }
}

// MARK: UndoRedoTextEditor Previews
struct UndoRedoTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = UndoRedoViewModel()
        UndoRedoTextEditor(viewModel: viewModel, isKeyboardFocused: true)
    }
}
