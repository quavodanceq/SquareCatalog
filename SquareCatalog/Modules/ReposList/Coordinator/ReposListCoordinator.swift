//
//  ReposListCoordinator.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit
import XCoordinator
import SafariServices

final class ReposListCoordinator: Coordinating.Navigation<ReposListRoute, Void> {
    
    private let listBuilder = ReposListBuilder()
    private let detailsBuilder = RepoDetailsBuilder()
    
    init() {
        super.init(root: UINavigationController(), initialRoute: .list)
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    override func prepareTransition(for route: ReposListRoute) -> NavigationTransition {
        switch route {
        case .list:
            listBuilder.register { [weak self] segue in
                guard let self else { return }
                switch segue {
                case .none:
                    break
                case .details(let repo):
                    self.perform(to: .details(repo), animated: true, completion: nil)
                }
            }
            return .set([listBuilder.make()], completion: .nop)
        case .details(let repo):
            detailsBuilder.register { [weak self] segue in
                guard let self else { return }
                switch segue {
                case .openURL(let url):
                    self.perform(to: .safari(url), animated: true, completion: nil)
                }
            }
            return .push(detailsBuilder.make(repo: repo))
        case .safari(let url):
            return .present(SFSafariViewController(url: url))
        }
    }
}
