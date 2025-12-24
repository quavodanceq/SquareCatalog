//
//  ReposListCoordinator.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

final class ReposListCoordinator {
    private let navigationController: UINavigationController
    private let builder = ReposListBuilder()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        builder.register { [weak self] segue in
            guard let self else { return }
            switch segue {
            case .none:
                break
            }
        }
        
        let vc = builder.make()
        navigationController.setViewControllers([vc], animated: false)
    }
}
