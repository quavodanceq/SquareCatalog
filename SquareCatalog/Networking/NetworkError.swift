//
//  NetworkError.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

enum NetworkError: Error {
    case invalidResponse
    case httpStatus(code: Int, body: String?)
    case decoding(Error)
}
