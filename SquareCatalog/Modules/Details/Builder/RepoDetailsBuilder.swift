//
//  RepoDetailsBuilder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

final class RepoDetailsBuilder {
    private var routing: ((RepoDetailsSegue) -> Void)?
    
    func register(routing: @escaping (RepoDetailsSegue) -> Void) {
        self.routing = routing
    }
    
    func make(repo: Repo) -> UIViewController {
        let vc = RepoDetailsViewController()
        let vm = RepoDetailsViewModel(repo: repo, routing: routing ?? { _ in })
        vc.bind(to: vm)
        return vc
    }
}
