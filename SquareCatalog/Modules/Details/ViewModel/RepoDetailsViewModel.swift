//
//  RepoDetailsViewModel.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import Foundation

final class RepoDetailsViewModel: ViewModelInterface<RepoDetailsState, RepoDetailsAction, RepoDetailsSegue> {
    
    init(repo: Repo, routing: @escaping (RepoDetailsSegue) -> Void) {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        
        let state = RepoDetailsState(
            title: repo.name,
            description: repo.description,
            githubURL: repo.htmlURL,
            stars: repo.stargazersCount,
            forks: repo.forksCount,
            issues: repo.openIssuesCount,
            language: repo.language,
            updatedText: "Updated \(df.string(from: repo.updatedAt))"
        )
        super.init(state: state, routing: routing)
    }
    
    override func dispatch(action: RepoDetailsAction) {
        switch action {
        case .openGitHub:
            routing(.openURL(state.githubURL))
        default:
            break
        }
    }
}
