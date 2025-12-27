//
//  Coordinator.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import Foundation
import UIKit
import XCoordinator

public enum Coordinating { }

public protocol CoordinatorType: XCoordinator.Coordinator where Self: AnyObject {
    
    var tasks: SynchronizedArray<Task<Void, Error>> { get set }
    func perform(to route: RouteType, animated: Bool, completion: Action?)
    func setRoot(window: UIWindow)
}

public extension CoordinatorType {
    
    func perform(to route: RouteType, animated: Bool, completion: Action?) {
        let task = Task<Void, Error> { @MainActor in
            self.trigger(route, with: XCoordinator.TransitionOptions(animated: animated), completion: completion?.execute)
        }
        tasks.append(task)
    }
    
    func setRoot(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
