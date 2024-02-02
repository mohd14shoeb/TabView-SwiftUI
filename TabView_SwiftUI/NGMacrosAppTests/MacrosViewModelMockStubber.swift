//
//  MacrosViewModelMockStubber.swift
//  NGMacrosAppTests
//
//  Created by Mohd Shoeb on 14/08/23.
//

import XCTest
@testable import NGMacrosApp

class MacrosViewModelMockStubber: MacrosServiceable {

    // MARK: common API
    func getAPI<T>(decodabel: T.Type, macrosApi: NGMacrosApp.MacrosApi, completion: @escaping (T?, String?) -> Void) where T: Decodable {
        let resource = self.getResourceName(macrosApi: macrosApi)
        self.request(macrosApi, resource: resource) { data, response, error in
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            } else {
                completion(nil, error?.localizedDescription)
            }
        }
    }
    
    func request(_ route: EndPointType,
                 resource: String?,
                 completion: @escaping NetworkRouterCompletion) {
        do {
            _ = try self.buildRequest(from: route)
            if let resource, !resource.isEmpty {
                let jsonData = readLocalFileData(file: resource, selfObject: self, fileExtentionType: "json")
                completion(jsonData, HTTPURLResponse(), nil)
                return
            }
        } catch {
            NetworkLogger.log(error: error)
            completion(nil, nil, error)
        }
        let response = HTTPURLResponse(url: route.baseURL,
                                       statusCode: 501,
                                       httpVersion: nil,
                                       headerFields: nil)
        completion(nil, response, nil)
    }
    
    // MARK: common HTTPURLResponse handle
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    func getResourceName(macrosApi: MacrosApi) -> String? {
        switch macrosApi {
        case .getMacrosResult:
            return "macrosMockResponse"
        case .getAllPosts:
            return "postsMockResponse"
        default: return ""
        }
    }
    
    private func buildRequest(from route: EndPointType) throws -> URLRequest {
        guard let base = URL(string: route.baseURL.absoluteString) else {
            fatalError("baseURL could not be configured.")}
        let baseAppend = base.appendingPathComponent(route.path).absoluteString.removingPercentEncoding ?? ""
        guard let url = URL(string: baseAppend) else { fatalError("baseURL could not be configured.")}
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }

}
