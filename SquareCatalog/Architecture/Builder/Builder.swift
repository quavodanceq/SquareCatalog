//
//  Builder.swift
//  SquareCatalog
//
//  Created by Куат Оралбеков on 24.12.2025.
//

public protocol BuilderType {
    
    associatedtype Segue: SegueType
    associatedtype Product
    
    func register(routing: @escaping (Segue) -> Void)
    
    func make() -> Product
    
}

public extension BuilderType {
    func register(routing: @escaping (Segue) -> Void) { }
}

