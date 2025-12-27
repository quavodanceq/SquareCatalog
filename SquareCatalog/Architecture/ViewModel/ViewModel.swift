//
//  ViewModel.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

import Foundation
import Combine

open class ViewModelInterface <State: StateType, Action: ActionType, Segue: SegueType>: ObservableObject {
    
    public typealias Routing = (Segue) -> Void
    
    @Published public var state: State
    public let routing: Routing
    
    public init(state: State = .initial, routing: @escaping Routing) {
        self.state = state
        self.routing = routing
    }
    
    open func dispatch(action: Action) { }
    
    open func reload() { }
    
    public func updateState(_ update: @escaping (inout State) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            var newState = self.state
            update(&newState)
            self.state = newState
        }
    }
}
