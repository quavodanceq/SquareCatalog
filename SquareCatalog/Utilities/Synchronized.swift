//
//  Synchronized.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 01.12.2025.
//

import Foundation

public final class SynchronizedArray<Element> {
    
    private let lock = NSLock()
    
    private var value: [Element]
    
    public init(_ value: [Element] = []) {
        self.value = value
    }
    
    public subscript(index: Int) -> Element {
        get {
            lock.synchronized { value[index] }
        }
        set {
            lock.synchronized { value[index] = newValue }
        }
    }
    
    public var count: Int {
        lock.synchronized {
            value.count
        }
    }
    
    public func append(_ element: Element) {
        lock.synchronized {
            value.append(element)
        }
    }
    
    public func remove(at index: Int) {
        lock.synchronized {
            value.remove(at: index)
        }
    }
}

public extension SynchronizedArray {
    func drain<Success, Failure>() where Element == Task<Success, Failure>, Failure: Error {
        lock.lock()
        value.forEach { $0.cancel() }
        value.removeAll()
        lock.unlock()
    }
}

