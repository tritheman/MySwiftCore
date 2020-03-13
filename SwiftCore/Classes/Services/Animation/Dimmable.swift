//
//  Dimmable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol defines the properties and methods for any object that wishes to show an animation when setting its alpha component.
 */
public protocol Dimmable { }

public extension Dimmable where Self : UIView {
    
    /**
     This method animates the opacity of a view. The timing function used is EaseOut.
     - parameter startAlpha: The starting alpha value of the view.
     - parameter endAlpha: The end alpha value of the view.
     - parameter duration: The duration of the animation.
     - parameter delay: The delay in seconds for the animation to start.
     - parameter completionHandler: An optional closure to execute once the animation is done.
     */
    public func motionDim(_ startAlpha : CGFloat, endAlpha : CGFloat, duration : Double, delay : Double = 0.0, completionHandler : (() -> ())? = nil) {
        
        self.alpha = startAlpha
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
            self.alpha = endAlpha
        }) { (finished) in
            completionHandler?()
            
        }
    }
}

/*
 This extension allows for the dim effect on the posters of the carousel cells.
 */
extension UIView : Dimmable { }
