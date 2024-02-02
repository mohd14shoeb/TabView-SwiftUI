//
//  SerachTextFieldView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct SerachTextFieldView: View {

    // MARK: Public properties
    @FocusState private var isKeyboardFocused: Bool
   // @Binding var isLoadingShowing: Bool
    @Binding var inputText: String
   // @Binding var errorMessage: String
    var searchButtonAction: ((_ searchCity: String?) -> Void)?

    // MARK: Body
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            textFieldView
            Spacer().frame(height: 5)
        }
        .frame(height: 130)
        .onAppear() {
            isKeyboardFocused = true
        }
        .onDisappear() {
            isKeyboardFocused = false
        }
        .onTapGesture {
            isKeyboardFocused = false
        }
    }

    @ViewBuilder
    private var textFieldView: some View {
        HStack {
            TextField("WeatherConstant.placeholderText,",
                      text: self.$inputText)
          //  .modifier(ProgressCircle(isLoadingShowing: $isLoadingShowing))
            .modifier(ClearButton(text: self.$inputText,
                                  clearButtonAction: {
                isKeyboardFocused = false
            }))
            .focused($isKeyboardFocused)
            .disableAutocorrection(true)
           // .disabled(isLoadingShowing)
            .onTapGesture {
                isKeyboardFocused = true
            }
            .onChange(of: self.inputText) { newValue in
                if !newValue.isEmpty {
                 //   self.errorMessage = ""
                }
            }
            .padding(.all, 10)
            .frame(width: 220, height: 40, alignment: .center)
            .fixedSize()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Button(action: {
                if !self.inputText.isEmpty {
                    isKeyboardFocused = false
                    self.searchButtonAction?(self.inputText)
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
           // .disabled(isLoadingShowing)
        }.padding([.leading, .trailing], 5)
    }
}

struct SerachTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SerachTextFieldView(inputText: .constant("hello"))
    }
}
