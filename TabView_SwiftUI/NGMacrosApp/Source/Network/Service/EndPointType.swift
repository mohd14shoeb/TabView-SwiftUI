//
//  EndPointType.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import Foundation

// MARK: Protocol EndPointType
protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
