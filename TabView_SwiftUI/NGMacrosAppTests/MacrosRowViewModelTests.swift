//
//  MacrosRowViewModelTests.swift
//  NGMacrosAppTests
//
//  Created by Mohd Shoeb on 21/08/23.
//

import XCTest
@testable import NGMacrosApp

final class MacrosRowViewModelTests: XCTestCase {
    
    // MARK: private Properties
    private var viewModel: MacrosRowViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let mockModel = mockMacrosData()
        self.viewModel = MacrosRowViewModel(model: mockModel,
                                            currentTab: 0) { _, _  in }
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        try super.tearDownWithError()
    }
    
    // MARK: Macros Test cases check property
    func testMacrosModelProperties() throws {
        let mockModel = mockMacrosData()
        let modelResponse = self.viewModel?.getModelProperties(model: mockModel,
                                                               currentIndex: 0)
        XCTAssertNotNil(modelResponse?.title)
        XCTAssertEqual(modelResponse?.title, "xyz@gmail.com")
        XCTAssertNotNil(modelResponse?.decription)
        XCTAssertEqual(modelResponse?.decription, " ssjhdsj sdfsdf asdsa")
    }
    
    // MARK: Post Test cases check property
    func testPostModelProperties() throws {
        let expectedTitle = "dolorem eum magni eos aperiam quia"
        let expectedDescription = "testing second string here"
        let mockModel = PostsModel(userID: 1,
                                   id: 601,
                                   title: expectedTitle,
                                   body: expectedDescription)
        let modelResponse = self.viewModel?.getModelProperties(model: mockModel,
                                                               currentIndex: 2)
        XCTAssertNotNil(modelResponse?.title)
        XCTAssertEqual(modelResponse?.title, expectedTitle)
        XCTAssertNotNil(modelResponse?.decription)
        XCTAssertEqual(modelResponse?.decription, expectedDescription)
    }
    
    func testButtonTapOptions() {
        let expectedTitle = "dolorem eum magni eos aperiam quia"
        let expectedDescription = "testing second string here"
        let mockModel = PostsModel(userID: 1,
                                   id: 601,
                                   title: expectedTitle,
                                   body: expectedDescription)
        self.viewModel?.buttonTapOptions(isShowPopover: false,
                                         oprationType: .edit,
                                         model: mockModel)
        XCTAssertNotNil(self.viewModel?.showPopover)
        XCTAssertEqual(self.viewModel?.showPopover, false)
    }
    
    func mockMacrosData() -> MacrosModel {
        let model = MacrosModel(gender: "M",
                                name: Name(title: "",
                                           first: "",
                                           last: ""),
                                location: Location(street: Street(number: 0,
                                                                  name: ""),
                                                   city: "ssjhdsj",
                                                   state: "sdfsdf",
                                                   country: "asdsa"),
                                email: "xyz@gmail.com",
                                phone: "",
                                cell: "",
                                nat: "")
        return model
    }
}
