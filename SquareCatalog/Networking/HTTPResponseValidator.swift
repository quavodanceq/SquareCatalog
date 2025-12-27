//
//  JSONResponseDecoder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 27.12.2025.
//

import Foundation

struct HTTPResponseValidator {
    func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw NetworkError.httpStatus(code: httpResponse.statusCode, body: body)
        }
    }
}


