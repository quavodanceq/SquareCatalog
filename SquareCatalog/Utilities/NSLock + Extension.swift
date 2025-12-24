//
//  NSLock + Extension.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 01.12.2025.
//

import Foundation

public extension NSLock {
    
    @discardableResult
    func synchronized<T>(_ task: () -> T) -> T {
        self.lock()
        defer { unlock() }
        return task()
    }
}
