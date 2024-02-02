//
//  ClearButton.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import SwiftUI

struct ClearButton: ViewModifier {

    // MARK: Public properties
    @Binding var text: String

    var clearButtonAction: (() -> Void)?

    public func body(content: Content) -> some View {
        HStack {
            content
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                        clearButtonAction?()
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
        }
    }
}
