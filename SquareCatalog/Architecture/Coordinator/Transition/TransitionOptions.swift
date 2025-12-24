//
//  TransitionOptions.swift
//  MusicStreamingBase
//
//  Created by Куат Оралбеков on 01.12.2025.
//

import UIKit

public struct TransitionOptions{
    
    public let animated: Bool
    public let presentationStyle: UIModalPresentationStyle
    public var transitionStyle: UIModalTransitionStyle
    public var capturesStatusBarAppearance: Bool
    
    public init(animated: Bool = true,
                presentationStyle: UIModalPresentationStyle = .automatic,
                transitionStyle: UIModalTransitionStyle = .coverVertical,
                capturesStatusBarAppearance: Bool = false) {
        self.animated = animated
        self.presentationStyle = presentationStyle
        self.transitionStyle = transitionStyle
        self.capturesStatusBarAppearance = capturesStatusBarAppearance
    }
}
