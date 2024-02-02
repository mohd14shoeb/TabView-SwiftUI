//
//  SearchBar.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct SearchBar: View {

    // MARK: Binding properties
    @Binding var text: String

    // MARK: Private properties
    @FocusState private var isKeyboardFocused: Bool
    @State private var isEditing = false

    // MARK: Body
    var body: some View {
        HStack {
            TextField("Search ", text: $text)
                .focused($isKeyboardFocused)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing && !self.text.isEmpty {
                            Button(action: {
                                self.text = ""
                                self.changeKeyBoardStatus(isKeyboardAppear: false)
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        } else {
                            Button(action: {
                                self.text = ""
                                self.changeKeyBoardStatus(isKeyboardAppear: false)
                            }) {
                                Image(systemName: "mic.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.changeKeyBoardStatus(isKeyboardAppear: true)
                }
                .onSubmit {
                    self.changeKeyBoardStatus(isKeyboardAppear: false)
                }
        }.onTapGesture {
            self.changeKeyBoardStatus(isKeyboardAppear: false)
        }.onDisappear {
            self.isKeyboardFocused = false
        }
    }

    // MARK: remove keyboard
    func changeKeyBoardStatus(isKeyboardAppear: Bool) {
        self.isEditing = isKeyboardAppear
        self.isKeyboardFocused = isKeyboardAppear
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
    }
}
