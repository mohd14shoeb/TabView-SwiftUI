//
//  UndoRedoViewModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 11/08/23.
//

import Foundation
import Combine

class UndoRedoViewModel: ObservableObject {
    
    // MARK: Public properties
    @Published var editText: String = ""
    @Published var undoText: [Character] = []
    
    // MARK: Private properties
    private var validStringChecker: AnyCancellable?
    
    // MARK: Initilizer
    init() {
        validStringChecker = $editText.sink { [weak self] newTypeText in
            if newTypeText.first == " " {
                var newValue = newTypeText
                if let spaceIndex = newValue.firstIndex(of: " ") {
                    newValue.remove(at: spaceIndex)
                    DispatchQueue.main.async {
                        self?.editText = newValue
                    }
                }
            }
        }
    }
    
    // MARK: Undo Function
    func undoType() {
        if let lastChar = editText.last {
            undoText.append(lastChar)
            editText = String(editText.dropLast())
        }
    }
    
    // MARK: Redo Function
    func redoType() {
        if let lastChar = undoText.last {
            undoText.removeLast()
            editText.append(lastChar)
        }
    }
    
    // MARK: Clear Property Value
    func clearAllText() {
        self.editText = ""
        self.undoText = []
    }
    
    // MARK: Macro Model Property Value
    func getMacroModelPropertyValue(macrosModel: Any?,
                                    currentTab: Int?) {
        guard let selectedTab = currentTab,
              let currentSelectedTab = TabBarSelected(rawValue: selectedTab) else {return}
        switch currentSelectedTab {
        case .myMacro:
            if let modelData = macrosModel as? MacrosModel {
                self.editText = modelData.fullAddress
            }
        case .posts:
            if let modelData = macrosModel as? PostsModel {
                self.editText = modelData.bodyText
            }
        case .clinicMacros:break
        }
    }
}
