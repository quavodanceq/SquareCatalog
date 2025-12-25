//
//  ReposListViewModelTests.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import XCTest
import Combine
@testable import SquareCatalog

final class ReposListViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func test_didLoad_success_setsRepos_andStopsLoading() {
        let apiClient = MockGitHubAPIClient(result: .success([
            Repo(
                name: "repo1",
                description: "desc",
                htmlURL: URL(string: "https://github.com/square/repo1")!,
                stargazersCount: 10,
                forksCount: 2,
                openIssuesCount: 1,
                language: "Swift",
                updatedAt: Date(),
                owner: RepoOwner(login: "square")
            )
        ]))
        
        let viewModel = ReposListViewModel(apiClient: apiClient, state: .initial) { _ in }
        
        let expectation = expectation(description: "Loaded repos")
        viewModel.$state
            .dropFirst()
            .sink { state in
                if state.isLoading == false, state.repos.count == 1 {
                    XCTAssertNil(state.errorMessage)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.dispatch(action: .view(.didLoad))
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_didLoad_failure_setsError_andStopsLoading() {
        let apiClient = MockGitHubAPIClient(result: .failure(URLError(.notConnectedToInternet)))
        let viewModel = ReposListViewModel(apiClient: apiClient, state: .initial) { _ in }
        
        let expectation = expectation(description: "Shows error")
        viewModel.$state
            .dropFirst()
            .sink { state in
                if state.isLoading == false, state.errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.dispatch(action: .view(.didLoad))
        
        wait(for: [expectation], timeout: 2)
    }
}

private final class MockGitHubAPIClient: GitHubAPIClientProtocol {
    
    private let result: Result<[Repo], Error>
    
    init(result: Result<[Repo], Error>) {
        self.result = result
    }
    
    func fetchSquareRepos() async throws -> [Repo] {
        switch result {
        case .success(let repos):
            return repos
        case .failure(let error):
            throw error
        }
    }
}
