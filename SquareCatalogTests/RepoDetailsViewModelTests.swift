//
//  RepoDetailsViewModelTests.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import XCTest
@testable import SquareCatalog

final class RepoDetailsViewModelTests: XCTestCase {
    
    func test_openGitHubTapped_routesOpenURL() {
        let repo = Repo(
            name: "repo1",
            description: nil,
            htmlURL: URL(string: "https://github.com/square/repo1")!,
            stargazersCount: 0,
            forksCount: 0,
            openIssuesCount: 0,
            language: nil,
            updatedAt: Date(),
            owner: RepoOwner(login: "square")
        )
        
        var routedSegues: [RepoDetailsSegue] = []
        let viewModel = RepoDetailsViewModel(repo: repo) { segue in
            routedSegues.append(segue)
        }
        
        viewModel.dispatch(action: .openGitHub)
        
        XCTAssertEqual(routedSegues.count, 1)
        switch routedSegues[0] {
        case .openURL(let url):
            XCTAssertEqual(url.absoluteString, "https://github.com/square/repo1")
        }
    }
}
