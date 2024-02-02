//
//  Router.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import Foundation

// MARK: typealias for routerCompletion response
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

// MARK: Protocol declare for NetworkRouter
protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

// MARK: Protocol Implementation for NetworkRouter
class Router<EndPoint: EndPointType>: NetworkRouter {

    // MARK: private  Properties
    private var task: URLSessionTask?

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request,
                                    completionHandler: { data, response, error in
                NetworkLogger.log(responseData: data,
                                  response: response, error: error)
                completion(data, response, error)
            })
        } catch {
            NetworkLogger.log(error: error)
            completion(nil, nil, error)
        }
        self.task?.resume()
    }

    func cancel() {
        self.task?.cancel()
    }

    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        guard let base = URL(string: route.baseURL.absoluteString) else { fatalError("baseURL could not be configured.") }
        let baseAppend = base.appendingPathComponent(route.path).absoluteString.removingPercentEncoding ?? ""
        guard let url = URL(string: baseAppend) else { fatalError("baseURL could not be configured.") }

        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue

//        switch route.task {
//        case .request:
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        }
        return request
    }
}
