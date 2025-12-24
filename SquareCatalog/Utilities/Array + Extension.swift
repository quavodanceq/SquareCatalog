//
//  Array + Extension.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 04.12.2025.
//

extension Collection {
    
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
