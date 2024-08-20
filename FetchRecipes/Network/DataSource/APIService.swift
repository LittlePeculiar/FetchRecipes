//
//  APIService.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/20/24.
//

import Foundation

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
