//
//  ReposListViewModel.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

class ReposListViewModel: ViewModelInterface<RepoListState, RepoListAction, RepoListSegue> {
    
    override func dispatch(action: RepoListAction) {
        switch action {
        case .view(.didLoad):
            updateState { state in
                state.repos = [
                    Repo(name: "first", description: "first repo description"),
                    Repo(name: "second", description: "second repo description"),
                    Repo(name: "third", description: nil)
                ]
            }
        default :
            break
        }
    }
    
    
}
