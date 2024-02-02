//
//  MacrosModel.swift
//  NGMacrosApp
//
//  Created by Mohd Shoeb on 09/08/23.
//

import Foundation

// MARK: - Root tag response
struct MacrosModelResponse: Decodable {
    let results: [MacrosModel]?
    let info: Info?
}

// MARK: - Results
struct MacrosModel: Codable, Identifiable {
    
    var id: String {
        guard let email = email else { return ""}
        return email
    }
    
    var fullAddress: String {
        guard let location = location,
              let name = location.street?.name,
              let city = location.city,
              let state = location.state,
              let country = location.country else { return ""}
        return "\(name) \(city) \(state) \(country)"
    }
    
    var emailID: String {
        guard let email = email else { return ""}
        return email
    }
    
    let gender: String?
    let name: Name?
    var location: Location?
    var email: String?
    var phone, cell: String?
    let nat: String?
    
}

// MARK: - Info
struct Info: Decodable {
    let seed: String?
    let results, page: Int?
    let version: String?
}

// MARK: - Location
struct Location: Codable {
    var street: Street?
    var city, state, country: String?
}

// MARK: - Street
struct Street: Codable {
    var number: Int?
    var name: String?
}

// MARK: - Name
struct Name: Codable {
    let title, first, last: String
}
