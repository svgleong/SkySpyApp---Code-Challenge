//
//  APIClient.swift
//  SkySpy
//
//  Created by SofiaLeong on 30/04/2025.
//

import Foundation

protocol APIClientProtocol {
    func fetchData(endpoint: Endpointable) async throws -> Data
}

final class APIClient: APIClientProtocol {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchData(endpoint: Endpointable) async throws -> Data {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            print("Requesting: \(url)")
            print("Status Code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            switch response.statusCode {
            case 200...299:
                return data
            case 401:
                throw NetworkError.unauthorized
            default:
                throw NetworkError.unexpectedStatusCode
            }
        } catch {
            throw NetworkError.unknown
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
}
