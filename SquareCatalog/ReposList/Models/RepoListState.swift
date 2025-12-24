//
//  RepoListState.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

struct RepoListState: StateType {
    var repos: [Repo]
    static var initial: RepoListState { .init(repos: []) }
}
