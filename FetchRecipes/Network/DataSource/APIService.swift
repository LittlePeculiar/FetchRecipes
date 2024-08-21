//
//  APIService.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/20/24.
//

import Foundation

enum Category: CaseIterable {
    // todo: additional categories here
    case dessert
    
    var apiEndpoint: APIEndpoint {
        switch self {
        case .dessert:
            return APIEndpoint.desserts
        }
    }
    
    var title: String {
        switch self {
        case .dessert:
            return "Dessert"
        }
    }
}

protocol APIService {
    func fetchData<T: Decodable>(
        payloadType: T.Type,
        from endpoint: APIEndpoint,
        body: Encodable?,
        method: Method
    ) async throws -> (Result<T?, APIError>)
}

// satisfy protocol for default params
extension APIService {
    func fetchData<T: Decodable>(
        payloadType: T.Type,
        from endpoint: APIEndpoint
    ) async throws -> (Result<T?, APIError>) {
        return try await fetchData(payloadType: payloadType, from: endpoint, body: nil, method: .GET)
    }
}
