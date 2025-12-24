//
//  Coordinator.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 28.11.2025.
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

extension Coordinating{
    
    public enum HashState {
        case parent(Int)
        case child(parent: Int, initial: Int)
        
        public var lastHash: Int {
            switch self {
            case let .parent(hash):
                return hash
            case let .child(_, hash):
                return hash
            }
        }
    }
    
    public protocol ChildCoordinator: Presentable {
        var id: String { get }
        var stillInStack: Bool { get }
        func setupHashState()
        func observeTransitions(_ result: Action)
        func performInitialRoutesIfNeeded(_ result: Action)
    }
}
