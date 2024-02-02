//
//  NetworkEnvironment.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import Foundation

// MARK: Enum Environment
enum APIEnvironment {
    case qaEnv
    case production
    case staging
}

struct NetworkEnvironment {

    // MARK: static properties
    static let environment: APIEnvironment = .qaEnv
    static var baseURL: String {
        switch environment {
        case .production: return "https://randomuser.me/"
        case .qaEnv: return "https://jsonplaceholder.typicode.com/"
        case .staging: return "https://randomuser.me/"
        }
    }
}
