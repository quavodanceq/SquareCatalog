//
//  JSONResponseDecoder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 27.12.2025.
//

import Foundation

struct JSONResponseDecoder {
    let decoder: JSONDecoder
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}


