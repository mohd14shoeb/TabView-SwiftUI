//
//  ReadingLocalFile.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 11/08/23.
//

import Foundation

// MARK: - Helper methods for reading LocalFile
func readLocalFileData(file: String, selfObject: AnyObject, fileExtentionType: String) -> Data? {
    if let jsonFilePath = Bundle(for: type(of: selfObject)).path(forResource: file, ofType: fileExtentionType) {
        let jsonFileURL = URL(fileURLWithPath: jsonFilePath)

        if let jsonData = try? Data(contentsOf: jsonFileURL) {
            return jsonData
        }
    }
    return nil
}

// MARK: - Helper methods for parsing the JSON file.
func parseJSON<T: Decodable>(decodabel: T.Type, jsonData: Data) -> T? {
    do {
        let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}
