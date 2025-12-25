//
//  GithubAPIClient.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import Foundation

protocol GitHubAPIClientProtocol {
    func fetchSquareRepos() async throws -> [Repo]
}

final class GitHubAPIClient: GitHubAPIClientProtocol {
    private let session: URLSession
    private let baseURL = URL(string: "https://api.github.com")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchSquareRepos() async throws -> [Repo] {
        let url = baseURL.appendingPathComponent("orgs/square/repos")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("SquareCatalog", forHTTPHeaderField: "User-Agent")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8)
            throw NetworkError.httpStatus(code: http.statusCode, body: body)
        }
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Repo].self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
