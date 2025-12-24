//
//  Actions.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 28.11.2025.
//

public struct Action {
    
    private let closure: () -> Void
    
    public init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    public func execute() {
        closure()
    }
}

public extension Action {
    static var nop: Action { .init(closure: {}) }
}

public struct GenericAction <Input, Output> {
    
    private let closure: (Input) -> Output
    
    public init(closure: @escaping (Input) -> Output) {
        self.closure = closure
    }
    
    @discardableResult public func execute(input: Input) -> Output {
        closure(input)
    }
}

public extension GenericAction where Output == Void {
    static func nop() -> GenericAction<Input, Void> {
        .init { _ in }
    }
}

public extension GenericAction where Input == Void {
    func execute() -> Output {
        closure(())
    }
}
