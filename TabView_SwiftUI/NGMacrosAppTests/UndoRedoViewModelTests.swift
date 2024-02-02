//
//  UndoRedoViewModelTests.swift
//  NGMacrosAppTests
//
//  Created by Mohd Shoeb on 21/08/23.
//

import XCTest
@testable import NGMacrosApp

final class UndoRedoViewModelTests: XCTestCase {
    
    // MARK: private Properties
    private var viewModel: UndoRedoViewModel?
    
    // MARK: setUp
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.viewModel = UndoRedoViewModel()
    }
    
    // MARK: tearDown
    override func tearDownWithError() throws {
        self.viewModel = nil
    }
    
    // MARK: Post Model Property check
    func testPostModelPropertyValue() throws {
        let editTextExpected = "dolorem eum magni eos aperiam quia"
        let postModel = PostsModel(userID: 1,
                                   id: 6,
                                   title: "hello its title",
                                   body: editTextExpected)
        self.viewModel?.getMacroModelPropertyValue(macrosModel: postModel,
                                                   currentTab: 2)
        XCTAssertNotNil(self.viewModel?.editText)
        XCTAssertEqual(self.viewModel?.editText,
                       editTextExpected)
    }
    
    // MARK: Macro Model Property check
    func testMacrosModelPropertyValue() throws {
        let editTextExpected = "near road dolorem eum magni eos aperiam quia MV IN"
        let postModel = self.getMacroModel(macroModel: nil,
                                           newCategory: "hello testing",
                                           newDescription: "dolorem eum magni eos aperiam quia",
                                           phone: "98-76-34-23-23")
        self.viewModel?.getMacroModelPropertyValue(macrosModel: postModel,
                                                   currentTab: 0)
        XCTAssertNotNil(self.viewModel?.editText)
        XCTAssertEqual(self.viewModel?.editText,
                       editTextExpected)
    }
    
    // MARK: Redo check test case
    func testRedoType() {
        self.viewModel?.editText = "hello"
        self.viewModel?.undoText = ["a", "b"]
        self.viewModel?.redoType()
        XCTAssertNotNil(self.viewModel?.editText)
        XCTAssertEqual(self.viewModel?.editText,
                       "hellob")
    }
    
    // MARK: Undo check test case
    func testUndoType() {
        self.viewModel?.editText = "hello"
        self.viewModel?.undoText = ["a", "b"]
        self.viewModel?.undoType()
        XCTAssertNotNil(self.viewModel?.editText)
        XCTAssertEqual(self.viewModel?.editText,
                       "hell")
    }
    
    // MARK: get MacroModel
    func getMacroModel(macroModel: MacrosModel?,
                       newCategory: String?,
                       newDescription: String?,
                       phone: String?) -> MacrosModel {
        let street = Street(number: 1001,
                            name: "near road")
        return MacrosModel(gender: "M",
                           name: Name(title: "Mr.",
                                      first: "abc",
                                      last: "lil"),
                           location: Location(street: street,
                                              city: newDescription,
                                              state: "MV",
                                              country: "IN"),
                           email: newCategory ?? "",
                           phone: phone,
                           cell: "06-52-35-76-85", nat: "FR")
    }
}
