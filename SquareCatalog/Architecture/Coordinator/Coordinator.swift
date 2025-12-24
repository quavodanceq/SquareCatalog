//
//  Coordinator.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 03.12.2025.
//

import XCoordinator
import UIKit

extension Coordinating {
    
    open class Navigation<Route: XCoordinator.Route, Localization>: XCoordinator.NavigationCoordinator<Route>, CoordinatorType {
        
        public var tasks: SynchronizedArray<Task<Void, Error>> = SynchronizedArray()
        
        init(root: UINavigationController, initialRoute: Route? = nil) {
            super.init(rootViewController: root, initialRoute: initialRoute)
        }
        
        public func perform(to route: Route, animated: Bool, completion: Action?) {
            trigger(route, with: .init(animated: animated)) { [weak self] in
                guard let self else {
                    completion?.execute()
                    return
                }
                completion?.execute()
            }
        }
        
        deinit {
            tasks.drain()
        }
    }
}

