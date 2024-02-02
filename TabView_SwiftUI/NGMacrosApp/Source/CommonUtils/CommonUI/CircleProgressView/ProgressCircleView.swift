//
//  ProgressCircleView.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import SwiftUI

struct ProgressCircleView: View {

    // MARK: Body
    var body: some View {
        VStack(alignment: .center) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.screenBackgroundColor))
                .padding(.vertical, 20)
        }
        .frame(width: 30, height: 30)
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
