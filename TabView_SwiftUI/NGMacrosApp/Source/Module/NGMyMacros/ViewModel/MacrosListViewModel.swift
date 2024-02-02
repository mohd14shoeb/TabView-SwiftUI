//
//  MacrosListViewModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 18/08/23.
//

import Foundation

struct MacrosListViewModel {
    
    // MARK: Private properties
    let currentTab: Int?
    let modelDataArray: [Any]?
    let onDeleteButtonTapped: (Any,
                               ButtonOperationType) -> Void
    
    // MARK: Initilizer
    init(currentTab: Int,
         modelDataArray: [Any],
         editOptionTapped: @escaping (Any, ButtonOperationType) -> Void) {
        self.currentTab = currentTab
        self.modelDataArray = modelDataArray
        self.onDeleteButtonTapped = editOptionTapped
    }
}
