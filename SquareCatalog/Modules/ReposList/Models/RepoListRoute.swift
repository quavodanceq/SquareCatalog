//
//  RepoListRoute.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 25.12.2025.
//

import XCoordinator
import Foundation

enum ReposListRoute: Route {
    case list
    case details(Repo)
    case safari(URL)
}
