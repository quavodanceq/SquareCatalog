//
//  RepoDetailsState.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import Foundation

struct RepoDetailsState: StateType {
    var title: String
    var description: String?
    var githubURL: URL
    var stars: Int
    var forks: Int
    var issues: Int
    var language: String?
    var updatedText: String
    
    static var initial: Self {
        .init(title: "", description: nil, githubURL: URL(string: "https://github.com")!,
              stars: 0, forks: 0, issues: 0, language: nil, updatedText: "")
    }
}
