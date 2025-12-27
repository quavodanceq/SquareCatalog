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
    private let userAgent: String
    private let responseValidator: HTTPResponseValidator
    private let responseDecoder: JSONResponseDecoder
    
    init(
        session: URLSession = .shared,
        userAgent: String = "SquareCatalog",
        responseValidator: HTTPResponseValidator = HTTPResponseValidator(),
        decoderFactory: JSONDecoderFactory = JSONDecoderFactory()
    ) {
        self.session = session
        self.userAgent = userAgent
        self.responseValidator = responseValidator
        self.responseDecoder = JSONResponseDecoder(decoder: decoderFactory.makeGitHubAPIDecoder())
    }
    
    func fetchSquareRepos() async throws -> [Repo] {
        let request = GitHubEndpoint.squareRepos.makeRequest(baseURL: baseURL, userAgent: userAgent)
        let (data, response) = try await session.data(for: request)
        try responseValidator.validate(response: response, data: data)
        return try responseDecoder.decode([Repo].self, from: data)
    }
}
