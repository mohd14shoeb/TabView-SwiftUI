//
//  PostsModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 18/08/23.
//

import Foundation

// MARK: - Root tag response
struct PostsModel: Codable {
    let userID, id: Int?
    var title, body: String?
    
    var titleText: String {
        guard let title = title else { return ""}
        return title
    }
    
    var bodyText: String {
        guard let body = body else { return ""}
        return body
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

 typealias PostsModelResponse = [PostsModel]
