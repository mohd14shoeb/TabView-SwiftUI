//
//  MacrosRowViewModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 18/08/23.
//

import Foundation

enum ButtonOperationType {
    case edit
    case delete
}

class MacrosRowViewModel: ObservableObject {
    
    // MARK: Public properties
    let model: Any?
    let currentTab: Int?
    let editOptionTapped: (Any?, ButtonOperationType) -> Void
    @Published var showPopover: Bool = false
    
    // MARK: Initilizer
    init(model: Any?,
         currentTab: Int?,
         showPopover: Bool = false,
         editOptionTapped: @escaping (Any, ButtonOperationType) -> Void) {
        self.model = model
        self.currentTab = currentTab
        self.showPopover = showPopover
        self.editOptionTapped = editOptionTapped
    }
    
    // MARK: Initilizer
    func getModelProperties(model: Any?,
                            currentIndex: Int?) -> (title: String,
                                                    decription: String) {
        guard let currentTab = currentIndex,
              let currentTab = TabBarSelected(rawValue: currentTab) else { return ("", "")}
        var title = ""
        var decription = ""
        switch currentTab {
        case .myMacro:
            if let macroModel = model as? MacrosModel {
                title = macroModel.emailID
                decription = macroModel.fullAddress
            }
        case .posts:
            if let postModel = model as? PostsModel {
                title = postModel.titleText
                decription = postModel.bodyText
            }
        case .clinicMacros:break
        }
        return (title, decription)
    }
    
    // MARK: Button TapOptions
    func buttonTapOptions(isShowPopover: Bool,
                          oprationType: ButtonOperationType,
                          model: Any?) {
        DispatchQueue.main.async {
            self.showPopover = isShowPopover
            self.editOptionTapped(model, oprationType)
        }
    }
}
