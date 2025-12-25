//
//  AppCoordinator.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private var rootCoordinator: ReposListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let coordinator = ReposListCoordinator()
        self.rootCoordinator = coordinator
        window.rootViewController = coordinator.rootViewController
        window.makeKeyAndVisible()
    }
}
