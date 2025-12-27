//
//  JSONResponseDecoder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 27.12.2025.
//

import Foundation

struct JSONDecoderFactory {
    func makeGitHubAPIDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}


