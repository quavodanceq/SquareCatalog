//
//  AppCoordinator.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var reposListCoordinator: ReposListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let flow = ReposListCoordinator(navigationController: navigationController)
        reposListCoordinator = flow
        flow.start()
    }
}
