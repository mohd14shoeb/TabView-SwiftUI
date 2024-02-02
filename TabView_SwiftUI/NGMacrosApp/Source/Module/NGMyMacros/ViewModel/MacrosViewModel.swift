//
//  MacrosViewModel.swift
//  NGMacrosApp

//  Created by Mohd Shoeb on 09/08/23.
//

import Foundation
import Combine

enum TabBarSelected: Int {
    case myMacro = 0
    case clinicMacros = 1
    case posts = 2
}

class MacrosViewModel: ObservableObject {
    
    // MARK: Private properties
    private let networkManager: MacrosServiceable
    private let group = DispatchGroup()
    private var validStringChecker: AnyCancellable?
    
    // MARK: Public properties
    let model: TabBarItemModel
    @Published var allTabResponseArray: [[String: Any]]?
    @Published var macrosModel: Any?
    @Published var isLoadingShowing = false
    @Published var showNextScreenView = false
    @Published var showsAlert = false
    @Published var alertErrorMessage: String?
    @Published var currentTab: Int = 0
    @Published var searchText = ""
    @Published var macroName: String = ""
    
    // MARK: Initilizer
    init(model: TabBarItemModel,
         networkManager: MacrosServiceable ) {
        self.model = model
        self.networkManager = networkManager
        self.initTextFieldValidation()
    }
    
    // MARK: Init for TextFieldValidation
    func initTextFieldValidation() {
        validStringChecker = $macroName.sink { [weak self] newTypeText in
            if newTypeText.first == " " {
                var newValue = newTypeText
                if let spaceIndex = newValue.firstIndex(of: " ") {
                    newValue.remove(at: spaceIndex)
                    DispatchQueue.main.async {
                        self?.macroName = newValue
                    }
                }
            }
        }
    }
    
    // MARK: clear Model value
    func clearEditModifyData() {
        self.macrosModel = nil
        self.macroName = ""
    }
    
    // MARK: Get Macro name property value
    func getMacroPropertyValue() {
        guard let currentSelectedTab = TabBarSelected(rawValue: self.currentTab) else {return}
        switch currentSelectedTab {
        case .myMacro:
            if let modelData = self.macrosModel as? MacrosModel {
                self.macroName = modelData.emailID
            }
        case .clinicMacros:break
        case .posts:
            if let modelData = self.macrosModel as? PostsModel {
                self.macroName = modelData.titleText
            }
        }
    }
    
    // MARK: search string in Model
    func searchDataModel(searchText: String,
                         currentTabIndex: Int) -> [Any] {
        var searchModelArray: [Any] = []
        if let selectedsearchModelArray = self.getSelectedTabArray(currentTabIndex: currentTabIndex),
           let currentTab = TabBarSelected(rawValue: currentTabIndex),
           !selectedsearchModelArray.isEmpty {
            switch currentTab {
            case .myMacro:
                if let macrosModelResponseArray = selectedsearchModelArray as? [MacrosModel],
                   !macrosModelResponseArray.isEmpty {
                    searchModelArray = macrosModelResponseArray.filter({
                        searchText.isEmpty ? true : $0.emailID.lowercased().contains(searchText.lowercased()) })
                }
            case .clinicMacros: break
            case .posts:
                if let macrosModelResponseArray = selectedsearchModelArray as? [PostsModel],
                   !macrosModelResponseArray.isEmpty {
                    searchModelArray = macrosModelResponseArray.filter({
                        searchText.isEmpty ? true : $0.titleText.lowercased().contains(searchText.lowercased()) })
                }
                
            }
        }
        return searchModelArray
    }
    
    // MARK: Get data Array of selected Tab
    func getSelectedTabArray(currentTabIndex: Int) -> [Any]? {
        let selectedTabDictionary = self.allTabResponseArray?.filter {
            ($0["tabBarSelected"]) as? Int == currentTabIndex}.first
        let selectedTabArray = selectedTabDictionary?["tabBarSelectedArray"] as? [Any] ?? []
        return selectedTabArray
    }
    
    // MARK: insert Model data Array into selected Tab
    func insertModelToSelectedTabArray(currentTabIndex: Int,
                                       modelArray: [Any]) {
        var selectedTabDictionary = self.allTabResponseArray?.filter {
            ($0["tabBarSelected"]) as? Int == currentTabIndex }.first
        selectedTabDictionary?["tabBarSelectedArray"] = modelArray
        guard let indexValue = self.allTabResponseArray?.firstIndex(where: {
            ($0["tabBarSelected"]) as? Int == currentTabIndex
        }) else { return }
        self.allTabResponseArray?[indexValue] = selectedTabDictionary ?? [:]
    }
    
    // MARK: Get Index for any Model data from Array
    func getModelIndexFromArray(macrosModel: Any,
                                tabIndex: Int) -> Int {
        if let selectedSearchModelArray = self.getSelectedTabArray(currentTabIndex: tabIndex),
           let currentTab = TabBarSelected(rawValue: tabIndex),
           !selectedSearchModelArray.isEmpty {
            switch currentTab {
            case .myMacro:
                let macrosModelArray = selectedSearchModelArray as? [MacrosModel] ?? []
                if let index = macrosModelArray.firstIndex(where: {
                    $0.id == (macrosModel as? MacrosModel)?.id }) {
                    return index
                }
            case .clinicMacros: break
            case .posts:
                let macrosModelArray = selectedSearchModelArray as? [PostsModel] ?? []
                if let index = macrosModelArray.firstIndex(where: {
                    $0.id == (macrosModel as? PostsModel)?.id }) {
                    return index
                }
            }
        }
        return -1
    }
    
    // MARK: Delete Model Data API
    func deleteModelData(macrosModel: Any, tabIndex: Int) {
        let modelIndex = self.getModelIndexFromArray(macrosModel: macrosModel,
                                                     tabIndex: tabIndex)
        if modelIndex >= 0 {
            if let selectedSearchModelArray = self.getSelectedTabArray(currentTabIndex: tabIndex),
               let currentTab = TabBarSelected(rawValue: tabIndex),
               !selectedSearchModelArray.isEmpty {
                switch currentTab {
                case .myMacro:
                    var macrosModelArray = selectedSearchModelArray as? [MacrosModel] ?? []
                    macrosModelArray.removeAll(where: {$0.id == (macrosModel as? MacrosModel)?.email})
                    self.insertModelToSelectedTabArray(currentTabIndex: tabIndex,
                                                       modelArray: macrosModelArray)
                case .clinicMacros: break
                case .posts:
                    var macrosModelArray = selectedSearchModelArray as? [PostsModel] ?? []
                    macrosModelArray.removeAll(where: {$0.id == (macrosModel as? PostsModel)?.id})
                    self.insertModelToSelectedTabArray(currentTabIndex: tabIndex,
                                                       modelArray: macrosModelArray)
                }
            }
        }
    }
    
    // MARK: Update Macro and Post Model
    func updateModelData(macrosModel: Any?,
                         tabIndex: Int?,
                         newCategory: String?,
                         newDescription: String?) {
        guard let selectedTabIndex = tabIndex else { return }
        if let macrosModel = macrosModel, let tabIndex = tabIndex {
            let modelIndex = self.getModelIndexFromArray(macrosModel: macrosModel,
                                                         tabIndex: selectedTabIndex)
            if modelIndex >= 0 {
                self.updateExistingModel(tabIndex: tabIndex,
                                         modelIndex: modelIndex,
                                         newCategory: newCategory,
                                         newDescription: newDescription)
            }
        } else {
            self.addNewModel(macrosModel: macrosModel,
                             tabIndex: selectedTabIndex,
                             newCategory: newCategory,
                             newDescription: newDescription)
        }
    }
    
    // MARK: Add New Macro Model
    func addNewMyMacrosModel(tabIndex: Int?,
                             macroModel: MacrosModel?,
                             newCategory: String?,
                             newDescription: String?) {
        guard let selectedTabIndex = tabIndex else { return }
        let newMacroModel = self.getMacroModel(macroModel: macroModel,
                                               newCategory: newCategory,
                                               newDescription: newDescription)
        if let selectedSearchModelArray = self.getSelectedTabArray(currentTabIndex: selectedTabIndex),
           !selectedSearchModelArray.isEmpty {
            var macrosModelArray = selectedSearchModelArray as? [MacrosModel] ?? []
            macrosModelArray.insert(newMacroModel, at: 0)
            self.insertModelToSelectedTabArray(currentTabIndex: selectedTabIndex,
                                               modelArray: macrosModelArray)
        } else {
            self.insertModelToSelectedTabArray(currentTabIndex: selectedTabIndex,
                                               modelArray: [newMacroModel])
        }
    }
    
    // MARK: Add New Post Model
    func addNewPostModel(tabIndex: Int?,
                         postModel: PostsModel?,
                         newCategory: String?,
                         newDescription: String?) {
        guard let selectedTabIndex = tabIndex else { return }
        var userIDGenrate = 0
        if let selectedSearchModelArray = self.getSelectedTabArray(currentTabIndex: selectedTabIndex),
           !selectedSearchModelArray.isEmpty {
            userIDGenrate = selectedSearchModelArray.count + 101
        }
        let post = PostsModel(userID: userIDGenrate,
                              id: userIDGenrate,
                              title: newCategory,
                              body: newDescription)
        if let selectedSearchModelArray = self.getSelectedTabArray(currentTabIndex: selectedTabIndex),
           !selectedSearchModelArray.isEmpty {
            var postsModelArray = selectedSearchModelArray as? [PostsModel] ?? []
            postsModelArray.insert(post, at: 0)
            self.insertModelToSelectedTabArray(currentTabIndex: selectedTabIndex,
                                               modelArray: postsModelArray)
        } else {
            self.insertModelToSelectedTabArray(currentTabIndex: selectedTabIndex,
                                               modelArray: [post])
        }
    }
    
    // MARK: update Existing Model
    func updateExistingModel(tabIndex: Int,
                             modelIndex: Int,
                             newCategory: String?,
                             newDescription: String?) {
        if let currentTab = TabBarSelected(rawValue: tabIndex) {
            switch currentTab {
            case .myMacro:
                var macrosModelArray = self.getSelectedTabArray(currentTabIndex: tabIndex) as? [MacrosModel] ?? []
                macrosModelArray[modelIndex].email = newCategory ?? ""
                macrosModelArray[modelIndex].location?.city = newDescription ?? ""
                self.insertModelToSelectedTabArray(currentTabIndex: tabIndex,
                                                   modelArray: macrosModelArray)
            case .posts:
                var macrosModelArray = self.getSelectedTabArray(currentTabIndex: tabIndex) as? [PostsModel] ?? []
                macrosModelArray[modelIndex].title = newCategory ?? ""
                macrosModelArray[modelIndex].body = newDescription ?? ""
                self.insertModelToSelectedTabArray(currentTabIndex: tabIndex,
                                                   modelArray: macrosModelArray)
            case .clinicMacros:break
            }
        }
    }
    
    // MARK: Update and Add Model Data API
    func addNewModel(macrosModel: Any?,
                     tabIndex: Int?,
                     newCategory: String?,
                     newDescription: String?) {
        guard let selectedTabIndex = tabIndex,
              let currentTab = TabBarSelected(rawValue: selectedTabIndex) else { return }
        switch currentTab {
        case .myMacro:
            self.addNewMyMacrosModel(tabIndex: selectedTabIndex,
                                     macroModel: macrosModel as? MacrosModel,
                                     newCategory: newCategory,
                                     newDescription: newDescription)
        case .posts:
            self.addNewPostModel(tabIndex: selectedTabIndex,
                                 postModel: macrosModel as? PostsModel,
                                 newCategory: newCategory,
                                 newDescription: newDescription)
            
        case .clinicMacros: break
        }
    }
    
    // MARK: All API response
    func getMacrosModelResponse() {
        self.allTabResponseArray?.removeAll()
        self.initTabResposeData()
        let jsonData = readLocalFileData(file: "macros",
                                         selfObject: self,
                                         fileExtentionType: "json")
        let current = parseJSON(decodabel: MacrosModelResponse.self,
                                jsonData: jsonData ?? Data())
        guard let modelResponse = current?.results  else {return}
        self.insertModelToSelectedTabArray(currentTabIndex: 0,
                                           modelArray: modelResponse)
        self.getAllPost()
        group.notify(queue: .main) {
            self.isLoadingShowing = false
        }
    }
    
    // MARK: initilize array of dictionary
    func initTabResposeData() {
        self.allTabResponseArray = [["tabBarSelectedArray": [Any](),
                                     "tabBarSelected": 0] as [String: Any],
                                    ["tabBarSelectedArray": [Any](),
                                     "tabBarSelected": 1],
                                    ["tabBarSelectedArray": [Any](),
                                     "tabBarSelected": 2]]
    }
    
    // MARK: All API response
    func getMacrosDataResponse() {
        group.enter()
        let macroApiName: MacrosApi = .getMacrosResult(totalResult: 10)
        self.getMacrosData(macrosApi: macroApiName,
                           model: MacrosModelResponse.self) { [weak self] (response, error) in
            if let error = error, !error.isEmpty {
                self?.alertErrorMessage = error
                self?.showsAlert = true
            }
            guard let modelResponse = response?.results  else {return}
            self?.insertModelToSelectedTabArray(currentTabIndex: 0,
                                                modelArray: modelResponse)
        }
        self.getAllPost()
        group.notify(queue: .main) {
            self.isLoadingShowing = false
        }
    }
    
    func getMacrosData<T: Decodable>(macrosApi: MacrosApi,
                                     model: T.Type,
                                     completion: @escaping (_ response: MacrosModelResponse?,
                                                            _ error: String?) -> Void) {
        self.isLoadingShowing = true
        self.networkManager.getAPI(decodabel: MacrosModelResponse.self,
                                   macrosApi: macrosApi) { [weak self] response, error in
            DispatchQueue.main.async {
                self?.group.leave()
                completion(response, error)
            }
        }
    }
    
    // MARK: get All Post Response API
    func getAllPost() {
        group.enter()
        self.isLoadingShowing = true
        self.getAllPostsResponse(macrosApi: .getAllPosts,
                                 model: PostsModelResponse.self,
                                 completion: { [weak self] (response, error) in
            DispatchQueue.main.async {
                if let error = error, !error.isEmpty {
                    self?.alertErrorMessage = error
                    self?.showsAlert = true
                } else {
                    self?.insertModelToSelectedTabArray(currentTabIndex: 2,
                                                        modelArray: response ?? [])
                }
                self?.group.leave()
            }
        })
    }
    
    func getAllPostsResponse<T: Decodable>(macrosApi: MacrosApi,
                                           model: T.Type,
                                           completion: @escaping (_ response: PostsModelResponse?,
                                                                  _ error: String?) -> Void) {
        self.networkManager.getAPI(decodabel: model,
                                   macrosApi: .getAllPosts,
                                   completion: { (response, error) in
            completion(response as? PostsModelResponse, error)
        })
    }
    
    // MARK: get MacroModel
    func getMacroModel(macroModel: MacrosModel?,
                       newCategory: String?,
                       newDescription: String?) -> MacrosModel {
        let street = Street(number: macroModel?.location?.street?.number,
                            name: macroModel?.location?.street?.name)
        return MacrosModel(gender: "M",
                           name: Name(title: "Mr.",
                                      first: "abc",
                                      last: "lil"),
                           location: Location(street: street,
                                              city: newDescription,
                                              state: macroModel?.location?.state,
                                              country: macroModel?.location?.country),
                           email: newCategory,
                           phone: macroModel?.phone,
                           cell: macroModel?.cell, nat: "")
    }
    
    // MARK: done BUtton Disable
    func doneButtonDisable(macroName: String?,
                           editText: String?) -> Bool {
        guard let macroName = macroName,
              let editText = editText else { return true}
        if macroName.isEmpty || editText.isEmpty {
            return true
        }
        return false
    }
}
