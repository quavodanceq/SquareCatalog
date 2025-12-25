//
//  RepoModel.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import Foundation

struct RepoOwner: Decodable, Equatable {
    let login: String
}

struct Repo: Decodable, Equatable {
    let name: String
    let description: String?
    
    let htmlURL: URL
    let stargazersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String?
    let updatedAt: Date
    let owner: RepoOwner
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case htmlURL = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case language
        case updatedAt = "updated_at"
        case owner
    }
}
