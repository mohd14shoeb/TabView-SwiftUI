//
//  MacrosEndPoints.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import Foundation

// MARK: Enum EndPoints
public enum MacrosApi {
    case getMacrosResult(totalResult: Int)
    case getAllPosts
    case none
}

// MARK: Enum Extension
extension MacrosApi: EndPointType {

    // MARK: properties
    var environmentBaseURL: String {
        return String(NetworkEnvironment.baseURL)
    }
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    var path: String {
        switch self {
        case .getMacrosResult(let totalResult):
            return "api/?results=\(totalResult)"
        case .getAllPosts:
            return "posts"
        default: return ""
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getMacrosResult, .getAllPosts:
            return .get
        default: return .delete
        }
    }

    var task: HTTPTask {
        switch self {
        case .getMacrosResult, .getAllPosts:
            return .request
        default: return .request
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }

}
