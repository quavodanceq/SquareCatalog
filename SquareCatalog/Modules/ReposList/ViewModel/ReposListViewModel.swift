//
//  ReposListViewModel.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

class ReposListViewModel: ViewModelInterface<RepoListState, RepoListAction, RepoListSegue> {
    
    private let apiClient: GitHubAPIClientProtocol
    
    init(
        apiClient: GitHubAPIClientProtocol,
        state: RepoListState = .initial,
        routing: @escaping (RepoListSegue) -> Void
    ) {
        self.apiClient = apiClient
        super.init(state: state, routing: routing)
    }
    
    override func dispatch(action: RepoListAction) {
        switch action {
        case .view(.didLoad), .retry:
            updateState { state in
                state.isLoading = true
                state.isRefreshing = false
                state.errorMessage = nil
            }
            Task {
                do {
                    let repos = try await apiClient.fetchSquareRepos()
                    updateState { state in
                        state.repos = repos
                        state.isLoading = false
                        state.isRefreshing = false
                    }
                } catch {
                    updateState { state in
                        state.isLoading = false
                        state.isRefreshing = false
                        state.errorMessage = "Failed to load repositories"
                    }
                }
            }
        case .refresh:
            updateState { state in
                state.isLoading = true
                state.isRefreshing = true
                state.errorMessage = nil
            }
            Task {
                do {
                    let repos = try await apiClient.fetchSquareRepos()
                    updateState { state in
                        state.repos = repos
                        state.isLoading = false
                        state.isRefreshing = false
                    }
                } catch {
                    updateState { state in
                        state.isLoading = false
                        state.isRefreshing = false
                        state.errorMessage = "Failed to refresh repositories"
                    }
                }
            }
        default :
            break
        }
    }
}
