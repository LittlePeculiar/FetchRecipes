//
//  API.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

import UIKit

/*
 for making all api calls
 fetch function takes
    model: codable struct
    endpoint: API endpoint
    method: default is GET
 
 returns
    Codable Model
 */

typealias NetworkResult = (data: Data, response: URLResponse)


class API: APIService {
    
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let cache = NSCache<NSString, NSData>()
    private var isReachable: Bool {
        NetworkMonitor.shared.isReachable
    }
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfig)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityChanged(notification:)),
            name: InAppNotification.connectivityDidChange.notification.name,
            object: nil
        )
    }
    
    @objc func connectivityChanged(notification _: NSNotification) {
            print("*** connectivity changed: \(NetworkMonitor.shared.isReachable)")
    }
}

extension API {
    func fetchData<T: Decodable>(
        payloadType: T.Type,
        from endpoint: APIEndpoint,
        body: Encodable?,
        method: Method
    ) async throws -> (Result<T?, APIError>) {
        
        var requestBody: Data?
            if let body = body, let jsonData = body.getJsonData() {
                requestBody = jsonData
            }
        
        if let request = try getUrlRequest(endpoint: endpoint, body: requestBody, method: method) {
            do {
                let result: NetworkResult = try await session.data(for: request, delegate: nil)
                guard let response = result.response as? HTTPURLResponse else {
                    return .failure(.noData)
                }
                switch response.statusCode {
                case 200...299:
                    guard let decodedResponse = try? decoder.decode(payloadType, from: result.data) else {
                        return .failure(.decodingError)
                    }
                    return .success(decodedResponse)
                default:
                    return .failure(.httpError(code: response.statusCode))
                }
            } catch {
                return .failure(.unknown)
            }
            
        }
        
        return .failure(.invalidRequest)
    }
    
    private func getUrlRequest(endpoint: APIEndpoint, body: Data?, method: Method) throws -> URLRequest? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"

        print("path: \(endpoint.path)")
        guard let url = URL(string: endpoint.path) else {
            throw APIError.badUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        if body != nil {
            urlRequest.httpBody = body
        }
        headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return urlRequest
    }
    
    func fetchImage(urlPath: String) async throws -> UIImage? {
        guard let imagePath = urlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let cacheId = NSString(string: imagePath)
        
        // first check cache
        if let imageData = cache.object(forKey: cacheId) as Data? {
            return UIImage(data: imageData)
        } else {
            // image not yet saved - fetch from api
            guard let url = URL(string: imagePath) else {
                return nil
            }
            
            let result: NetworkResult = try await session.data(from: url, delegate: nil)
            let imageData = result.data
            
            if let image = UIImage(data: imageData),
               let data = image.jpegData(compressionQuality: 1.0) {
                self.cache.setObject(data as NSData, forKey: cacheId)
                return image
            }
        }
        return nil
    }
}

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

extension Encodable {
    func getJsonData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
