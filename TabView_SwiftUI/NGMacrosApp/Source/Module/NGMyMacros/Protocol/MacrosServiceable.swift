//
//  MacrosServiceable.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 10/08/23.
//

import Foundation

// MARK: protocol MacrosServiceable
protocol MacrosServiceable {
    func getAPI<T: Decodable>(decodabel: T.Type,
                              macrosApi: MacrosApi,
                              completion: @escaping (_ response: T?,
                                                    _ error: String?) -> Void)
}
