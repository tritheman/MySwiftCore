//
//  MovableAndDimmable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol defines the properties and methods for any object that wishes to show an animation when setting its alpha component, as well as moving.
 */
public protocol MovableAndDimmable : Movable, Dimmable { }

extension MovableAndDimmable where Self : UIView {
    
    /**
     This method is tailored for the "Building Carousels" animation of the design specs.
     - parameter delay: The delay in seconds for the animation to start.
     - parameter completionHandler: An optional closure to execute once the animation is done.
     */
    public func moveAndDim(_ delay : Double, completionHandler : (() -> ())? = nil) {
        let height = UIScreen.main.bounds.height * 0.03
        let offset = CGPoint(x: 0, y: height)
        motionMove(offset, endOffset: CGPoint.zero, duration: 0.3, delay: delay) {
            completionHandler?()
        }
        motionDim(0, endAlpha: 1, duration: 0.3, delay: delay) {
        }
    }
}

/*
 This extension allows for the move and dim effect on the posters of the carousel cells.
 */
extension UIView : MovableAndDimmable { }
