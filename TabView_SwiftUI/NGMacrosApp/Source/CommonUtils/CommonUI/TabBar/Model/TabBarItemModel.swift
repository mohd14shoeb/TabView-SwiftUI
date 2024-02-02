//
//  TabBarItemModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import Foundation
import SwiftUI

struct TabBarItemModel {

    // MARK: Public Property
    let selectedItemColor: Color?
    let unselectedItemColor: Color?
    let tabBarOptions: [String]?

    var tabBarArray: [String] {
        self.tabBarOptions ?? []
    }

    var selecteTabColor: Color {
        self.selectedItemColor ?? Color.blue
    }

    var unSelecteTabColor: Color {
        self.unselectedItemColor ?? Color.black
    }

}
