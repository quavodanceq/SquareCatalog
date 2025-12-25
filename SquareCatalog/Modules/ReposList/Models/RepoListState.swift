//
//  RepoListState.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

struct RepoListState: StateType {
    var repos: [Repo]
    var isLoading: Bool
    var isRefreshing: Bool
    var errorMessage: String?
    static var initial: Self { .init(repos: [], isLoading: false, isRefreshing: false, errorMessage: nil) }
}
