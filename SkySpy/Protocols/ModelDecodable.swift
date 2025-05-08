//
//  ModelDecodable.swift
//  SkySpy
//
//  Created by SofiaLeong on 30/04/2025.
//

import Foundation

protocol ModelDecodable {
    func model<T: Decodable>(from data: Data, as type: T.Type) throws -> T
}

extension ModelDecodable {
    func model<T: Decodable>(from data: Data, as type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding failed for type: \(T.self)")
            print(data)
            print("Error: \(error)")
            throw error
        }
    }
}
