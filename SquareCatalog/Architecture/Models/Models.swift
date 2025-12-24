//
//  Models.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 27.11.2025.
//

public protocol ActionType: Equatable {
    
}

public enum Actions {
    public enum View: ActionType {
        case didLoad
        case willAppear
        case didAppear
        case willDisappear
        case didDisappear
    }
}

public protocol StateType: Equatable {
    
    static var initial: Self { get }
    
}

public protocol SegueType: Equatable {
    
}
