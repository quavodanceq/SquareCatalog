//
//  Transition.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 01.12.2025.
//

import XCoordinator
import UIKit

extension Transition where RootViewController == UIViewController {
    
    static func present(_ presentable: Presentable, animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { root, options, completionHandler in
            root.present(presentable.viewController,
                         animated: options.animated) {
                completion?.execute()
                completionHandler?()
            }
        }
    }
    
    static func dismiss(animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [], animationInUse: nil) { root, options, completionHandler in
            root.dismiss(animated: options.animated) {
                completion?.execute()
                completionHandler?()
            }
        }
    }
    
    
    static func embedReplacing(_ presentable: Presentable, transitionOptions: EmbedTransitionOptions? = .default, animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { root, options, completion in
            root.embedReplacing(
                to: presentable.viewController,
                in: root,
                options: transitionOptions
            ) {
                presentable.presented(from: root)
                completion?()
            }
        }
    }
    
    static func none(completion: Action? = nil) -> Transition {
        Transition(presentables: [], animationInUse: nil) { _, _, completionHandler in
            completion?.execute()
            completionHandler?()
        }
    }
}

private extension UIViewController {
    
    func embedReplacing(
        to viewController: UIViewController,
        in container: Container,
        options: EmbedTransitionOptions?,
        completion: PresentationHandler?
    ) {
        let current = container.viewController.children.first
        guard current !== viewController else {
            completion?()
            return
        }
        if let current = current, let options = options {
            addChild(viewController)
            transition(
                from: current,
                to: viewController,
                duration: options.duration,
                options: options.animationOptions,
                animations: { },
                completion: { _ in
                    current.view.removeFromSuperview()
                    current.removeFromParent()
                    current.didMove(toParent: nil)
                    
                    viewController.didMove(toParent: self)
                    completion?()
                }
            )
            return
        }
        removeAllChildren(from: container)
        viewController.willMove(toParent: self)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        view.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        viewController.didMove(toParent: self)
        completion?()
    }
    
    func removeAllChildren(from container: Container) {
        container.viewController.children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
            $0.didMove(toParent: nil)
        }
    }
}

public struct EmbedTransitionOptions {
    public let duration: TimeInterval
    public let animationOptions: UIView.AnimationOptions
    
    public init(duration: TimeInterval, animationOptions: UIView.AnimationOptions) {
        self.duration = duration
        self.animationOptions = animationOptions
    }
    
    public static var `default`: Self {
        .init(duration: 0.25, animationOptions: .transitionCrossDissolve)
    }
}

public extension Transition {
    
    static func multiple(
        _ transitions: [Transition],
        completion: Action? = nil
    ) -> Transition {
        Transition(presentables: [], animationInUse: nil) { root, options, completionHandler in
            guard !transitions.isEmpty else {
                completion?.execute()
                completionHandler?()
                return
            }
            
            func performNext(at index: Int) {
                guard index < transitions.count else {
                    completion?.execute()
                    completionHandler?()
                    return
                }
                
                let transition = transitions[index]
                transition.perform(
                    on: root,
                    with: options,
                    completion: {
                        performNext(at: index + 1)
                    }
                )
            }
            performNext(at: 0)
        }
    }
}

public extension Transition where RootViewController == UINavigationController {
    
    static func push(_ presentable: Presentable, animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { root, options, completionHandler in
            root.pushViewController(presentable.viewController, animated: options.animated)
            completion?.execute()
            completionHandler?()
        }
    }
    
    static func pop(animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [], animationInUse: nil) { root, options, completionHandler in
            root.popViewController(animated: options.animated)
            completion?.execute()
            completionHandler?()
        }
    }
    
    static func pop(to presentable: Presentable,animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [presentable], animationInUse: nil) { root, options, completionHandler in
            if let target = root.viewControllers.first(where: {
                $0 === presentable.viewController
            }) {
                root.popToViewController(target, animated: options.animated)
                completion?.execute()
                completionHandler?()
            } else {
                completion?.execute()
                completionHandler?()
            }
        }
    }
    
    static func popToRoot(animation: Animation? = nil, completion: Action? = nil) -> Transition {
        Transition(presentables: [], animationInUse: nil) { root, options, completionHandler in
            root.popToRootViewController(animated: options.animated)
            completion?.execute()
            completionHandler?()
        }
    }
    
    static func before(_ preTransition: Transition, run transition: Transition, completion: Action? = nil) -> Transition {
        Transition(presentables: [], animationInUse: nil) { root, options, completionHandler in
            preTransition.perform(on: root, with: options) {
                transition.perform(on: root, with: options) {
                    completion?.execute()
                    completionHandler?()
                }
            }
        }
    }
    
    static func set(_ presentables: [Presentable], completion: Action? = nil) -> Transition {
        Transition(presentables: presentables, animationInUse: nil) { root, options, completionHandler in
            root.setViewControllers(presentables.map {
                $0.viewController
            }, animated: options.animated)
            for presentable in presentables {
                presentable.presented(from: root)
            }
            completion?.execute()
            completionHandler?()
        }
    }
    
    static func replace(_ presentable: Presentable, with newPresentable: Presentable, completion: Action? = nil) -> Transition {
        Transition(presentables: [newPresentable], animationInUse: nil) { root, options, completionHandler in
            if let index = root.viewControllers.firstIndex(where: {
                $0 === presentable.viewController
            }) {
                var newStack = root.viewControllers
                newStack[index] = newPresentable.viewController
                root.setViewControllers(newStack, animated: options.animated)
                newPresentable.presented(from: root)
                completion?.execute()
                completionHandler?()
            } else {
                completion?.execute()
                completionHandler?()
            }
        }
    }
}
