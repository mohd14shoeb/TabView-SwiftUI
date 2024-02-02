//
//  MacrosViewModelTests.swift
//  NGMacrosAppTests
//
//  Created by Mohd Shoeb on 14/08/23.
//

import XCTest
@testable import NGMacrosApp

final class MacrosViewModelTests: XCTestCase {
    
    // MARK: private Properties
    private var viewModel: MacrosViewModel?
    private let expectedResult = "Bad request"
    
    // MARK: SetUp properties
    override func setUpWithError() throws {
        try super.setUpWithError()
        let model = TabBarItemModel(selectedItemColor: .screenBackgroundColor,
                                    unselectedItemColor: .black,
                                    tabBarOptions: ["MY MACROS", "CLINIC MACROS", "POSTS"])
        self.viewModel = MacrosViewModel(model: model,
                                         networkManager: MacrosViewModelMockStubber())
        self.getMacrosMockDataModelResponse()
    }
    
    // MARK: tearDown properties
    override func tearDownWithError() throws {
        self.viewModel?.allTabResponseArray?.removeAll()
        self.viewModel = nil
        super.tearDown()
    }
    
    // MARK: Mocros Test cases to get Model Index in Array
    func testModelIndexFromArrayNotFound() {
        let expectedResult = -1
        let macroModel = self.getMacroModel(macroModel: nil,
                                            newCategory: "harlotte.berger@example.com",
                                            newDescription: "hello india",
                                            phone: "")
        let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: macroModel,
                                                                tabIndex: 0)
        XCTAssertNotNil(indexValue)
        XCTAssertEqual(indexValue, expectedResult)
    }
    
    // MARK: Macros Model Index check in Array
    func testModelIndexFromArrayFound() {
        let expectedResult = 1
        let macroModel = self.getMacroModel(macroModel: nil,
                                            newCategory: "charlotte.berger@example.com",
                                            newDescription: "hello india",
                                            phone: "04-64-60-21-79")
        let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: macroModel,
                                                                tabIndex: 0)
        XCTAssertNotNil(indexValue)
        XCTAssertEqual(indexValue, expectedResult)
    }
    
    // MARK: Macros Model Index check in Blank Array
    func testModelIndexFromBlankArray() {
        let expectedResult = -1
        let macroModel = self.getMacroModel(macroModel: nil,
                                            newCategory: "charlotte.berger@example.com",
                                            newDescription: "hello india",
                                            phone: "04-64-60-21-79")
        let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: macroModel,
                                                                tabIndex: 1)
        XCTAssertEqual(indexValue, expectedResult)
    }
    
    // MARK: Macros Test cases delete Model from Array
    func testDeleteModelData() {
        let expectedResult = 9
        let macroModel = self.getMacroModel(macroModel: nil,
                                            newCategory: "charlotte.berger@example.com",
                                            newDescription: "hello india",
                                            phone: "04-64-60-21-79")
        self.viewModel?.deleteModelData(macrosModel: macroModel,
                                        tabIndex: 0)
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: 0)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Macros Add NewModel  into existing Array
    func testAddNewModelToResponseArray() {
        let expectedResult = 11
        self.viewModel?.addNewModel(macrosModel: nil,
                                    tabIndex: 0,
                                    newCategory: "axtharlotte11.berger@example.com",
                                    newDescription: "hello india11")
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: 0)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Macros Add NewModel To Blank Array
    func testAddNewModelToBlankResponseArray() {
        let expectedResult = 1
        self.viewModel?.insertModelToSelectedTabArray(currentTabIndex: 0,
                                                      modelArray: [])
        self.viewModel?.updateModelData(macrosModel: nil,
                                        tabIndex: 0,
                                        newCategory: "axtharlotte11.berger@example.com",
                                        newDescription: "hello india11")
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: 0)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Macros Update Existing Model
    func testUpdateExistingModelToResponseArray() {
        let expectedResult = 10
        let newMacroModel = self.getMacroModel(macroModel: nil,
                                               newCategory: "charlotte.berger@example.com",
                                               newDescription: "newDescription hello",
                                               phone: "04-64-60-21-79")
        self.viewModel?.updateModelData(macrosModel: newMacroModel,
                                        tabIndex: 0,
                                        newCategory: "charlotte.berger@example.com",
                                        newDescription: "hello india11")
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: 0)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Macros Done Button Disable
    func testDoneButtonDisable() {
        let expectedResult = true
        let response = self.viewModel?.doneButtonDisable(macroName: "",
                                                         editText: "")
        XCTAssertNotNil(response)
        XCTAssertEqual(response, expectedResult)
    }
    
    // MARK: Macros Done Button Enable
    func testDoneButtonEnable() {
        let expectedResult = false
        let response = self.viewModel?.doneButtonDisable(macroName: "hello",
                                                         editText: "its testing")
        XCTAssertNotNil(response)
        XCTAssertEqual(response, expectedResult)
    }
    
    // MARK: Macros TextField Validation
    func testInitTextFieldValidation() {
        self.viewModel?.macroName = " "
        self.viewModel?.initTextFieldValidation()
        XCTAssertNotEqual(self.viewModel?.macroName, "")
    }
    
    // MARK: Macros Data Response SucccessTest cases
    func testGetMacrosDataSucccess() {
        let expectedResult = 10
        let macroApiName: MacrosApi = .getMacrosResult(totalResult: 10)
        self.viewModel?.getMacrosData(macrosApi: macroApiName,
                                      model: MacrosModelResponse.self,
                                      completion: { [weak self] (response, error) in
            if let error = error, !error.isEmpty {
                self?.viewModel?.alertErrorMessage = error
            }
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.results?.count, expectedResult)
        })
    }
    
    // MARK: Macros Data Response Failure Test cases
    func testGetMacrosDataFailure() {
        let expectedResult = "Bad request"
        self.viewModel?.getMacrosData(macrosApi: .none,
                                      model: MacrosModelResponse.self,
                                      completion: { [weak self] (_, error) in
            if let error = error, !error.isEmpty {
                self?.viewModel?.alertErrorMessage = error
                self?.viewModel?.showsAlert = true
            }
            XCTAssertNotNil(self?.viewModel?.alertErrorMessage )
            XCTAssertEqual(self?.viewModel?.alertErrorMessage, expectedResult)
        })
    }
    
    // MARK: Post Data Response
    func testGetPostsDataSucccess() {
        let expectedResult = 10
        let macroApiName: MacrosApi = .getAllPosts
        self.viewModel?.getAllPostsResponse(macrosApi: macroApiName,
                                            model: PostsModelResponse.self,
                                            completion: { [weak self] (response, error) in
            if let error = error, !error.isEmpty {
                self?.viewModel?.alertErrorMessage = error
            }
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.count, expectedResult)
        })
    }
    
    // MARK: Macros Data Response nil Test cases
    func testgetMacrosDataResponse() {
        self.viewModel?.getMacrosDataResponse()
        XCTAssertNil(self.viewModel?.alertErrorMessage)
        XCTAssertEqual(self.viewModel?.showsAlert, false)
        
    }
    
    // MARK: Macros property value Test cases
    func testMacrosPropertyValue() {
        let expectedTitle = "charlotte.berger@example.com"
        let expecteddescription = "newDescription hello"
        let newMacroModel = self.getMacroModel(macroModel: nil,
                                               newCategory: expectedTitle,
                                               newDescription: expecteddescription,
                                               phone: "04-64-60-21-79")
        self.viewModel?.currentTab = 0
        self.viewModel?.macrosModel = newMacroModel
        self.viewModel?.getMacroPropertyValue()
        XCTAssertNotNil(self.viewModel?.macroName)
        XCTAssertEqual(self.viewModel?.macroName, expectedTitle)
    }
    
    // MARK: Macros Search Test cases
    func testMacroModelSearchDataModel() {
        self.getMacrosMockDataModelResponse()
        let searchFilterArray = self.viewModel?.searchDataModel(searchText: "charlotte.berger@example.com",
                                                                currentTabIndex: 0)
        XCTAssertEqual(searchFilterArray?.count, 1)
    }
    
    func testMacroModelSearchDataModelNotFound() {
        self.getMacrosMockDataModelResponse()
        let searchFilterArray = self.viewModel?.searchDataModel(searchText: "hello@gmail.com",
                                                                currentTabIndex: 1)
        XCTAssertEqual(searchFilterArray?.count, 0)
    }
    
    // MARK: Post Test cases to get Model Index in Array
    func testPostsModelIndexFromArrayNotFound() {
        let expectedResult = -1
        let postModel = PostsModel(userID: 1,
                                   id: 601,
                                   title: "dolorem eum magni eos aperiam quia",
                                   body: "to cold weather here")
        self.getPostsMockDataModelResponse()
        let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: postModel,
                                                                tabIndex: 2)
        XCTAssertNotNil(indexValue)
        XCTAssertEqual(indexValue, expectedResult)
    }
    
    // MARK: Post Test cases to get Model Index in Array
    func testPostsModelIndexFromArrayFound() {
        let expectedResult = 5
        let postModel = PostsModel(userID: 1,
                                   id: 6,
                                   title: "dolorem eum magni eos aperiam quia",
                                   body: "to cold weather here")
        
        self.getPostsMockDataModelResponse()
        let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: postModel,
                                                                tabIndex: 2)
        XCTAssertNotNil(indexValue)
        XCTAssertEqual(indexValue, expectedResult)
    }
    
    // MARK: Posts Test cases delete Model from Array
    func testDeletePostsModelData() {
        let expectedResult = 9
        let tabIndex = 2
        let postModel = PostsModel(userID: 1,
                                   id: 6,
                                   title: "dolorem eum magni eos aperiam quia",
                                   body: "to cold weather here")
        self.getPostsMockDataModelResponse()
        self.viewModel?.deleteModelData(macrosModel: postModel,
                                        tabIndex: tabIndex)
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: tabIndex)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Post Test cases to add Model into Array
    func testAddNewPostModelToResponseArray() {
        let expectedResult = 11
        let tabIndex = 2
        self.getPostsMockDataModelResponse()
        self.viewModel?.addNewModel(macrosModel: nil,
                                    tabIndex: tabIndex,
                                    newCategory: "dolorem eum magni eos aperiam quia",
                                    newDescription: "hello india11")
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: tabIndex)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Post Test cases to add new Model into blank Array
    func testAddNewPostModelToBlankResponseArray() {
        let expectedResult = 1
        let tabIndex = 2
        self.viewModel?.insertModelToSelectedTabArray(currentTabIndex: tabIndex,
                                                      modelArray: [])
        self.viewModel?.updateModelData(macrosModel: nil,
                                        tabIndex: tabIndex,
                                        newCategory: "dolorem eum magni eos aperiam quia",
                                        newDescription: "hello india")
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: tabIndex)
        XCTAssertNotNil(selectedTabArray)
        XCTAssertEqual(selectedTabArray?.count, expectedResult)
    }
    
    // MARK: Post Test cases to update a existing Model
    func testUpdateExistingPostModelToResponseArray() {
        let tabIndex = 2
        let titleTextexpected = "charlotte.berger@example.com"
        let descriptionExpected = "hello its new updated value"
        let postModel = PostsModel(userID: 1,
                                   id: 6,
                                   title: "dolorem eum magni eos aperiam quia",
                                   body: "to cold weather here")
        self.getPostsMockDataModelResponse()
        self.viewModel?.updateModelData(macrosModel: postModel,
                                        tabIndex: tabIndex,
                                        newCategory: titleTextexpected,
                                        newDescription: descriptionExpected)
        let selectedTabArray = self.viewModel?.getSelectedTabArray(currentTabIndex: tabIndex) as? [PostsModel] ?? []
        guard let indexValue = self.viewModel?.getModelIndexFromArray(macrosModel: postModel,
                                                                      tabIndex: 2) else { return }
        let responseTitle =  selectedTabArray[indexValue].titleText
        let responseDescription =  selectedTabArray[indexValue].bodyText
        
        XCTAssertNotNil(responseTitle)
        XCTAssertEqual(responseTitle, titleTextexpected)
        XCTAssertNotNil(responseDescription)
        XCTAssertEqual(responseDescription, descriptionExpected)
    }
    
    // MARK: Post Search Test cases
    func testPostModelSearchDataModel() {
        self.getPostsMockDataModelResponse()
        let searchFilterArray = self.viewModel?.searchDataModel(searchText: "dolorem eum magni eos aperiam quia",
                                                                currentTabIndex: 2)
        XCTAssertEqual(searchFilterArray?.count, 1)
    }
    
    // MARK: Post property value Test cases
    func testPostPropertyValue() {
        let expectedTitle = "dolorem eum magni eos aperiam quia"
        let expecteddescription = "hey its testing text"
        let postModel = PostsModel(userID: 1,
                                   id: 6,
                                   title: expectedTitle,
                                   body: expecteddescription)
        self.viewModel?.currentTab = 2
        self.viewModel?.macrosModel = postModel
        self.viewModel?.getMacroPropertyValue()
        XCTAssertNotNil(self.viewModel?.macroName)
        XCTAssertEqual(self.viewModel?.macroName, expectedTitle)
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
                                              state: macroModel?.location?.state,
                                              country: macroModel?.location?.country),
                           email: newCategory ?? "",
                           phone: phone,
                           cell: "06-52-35-76-85", nat: "FR")
    }
    
    // MARK: Macros Mock Data for test cases
    func getMacrosMockDataModelResponse() {
        self.viewModel?.allTabResponseArray?.removeAll()
        let jsonData = readLocalFileData(file: "macrosMockResponse",
                                         selfObject: self,
                                         fileExtentionType: "json")
        let current = parseJSON(decodabel: MacrosModelResponse.self,
                                jsonData: jsonData ?? Data())
        guard let modelResponse: [Any] = current?.results  else {return}
        self.viewModel?.initTabResposeData()
        self.viewModel?.insertModelToSelectedTabArray(currentTabIndex: 0,
                                                      modelArray: modelResponse)
    }
    
    // MARK: Posts Mock Data for test cases
    func getPostsMockDataModelResponse() {
        self.viewModel?.allTabResponseArray?.removeAll()
        let jsonData = readLocalFileData(file: "postsMockResponse",
                                         selfObject: self,
                                         fileExtentionType: "json")
        let current = parseJSON(decodabel: PostsModelResponse.self,
                                jsonData: jsonData ?? Data())
        guard let modelResponse: [Any] = current  else {return}
        self.viewModel?.initTabResposeData()
        self.viewModel?.insertModelToSelectedTabArray(currentTabIndex: 2,
                                                      modelArray: modelResponse)
    }
}
