//
//  Flashable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol defines the properties and methods for any object that wishes to show a continuous flashing animation between two colors.
 */
public protocol Flashable  { }

public extension Flashable where Self : UIView {
    
    /**
     This method is tailored for the "global banner" animation of the design specs.
     - parameter toColor: The color the animation will start with.
     - parameter fromColor: The color the animation will end with.
     - parameter duration: is how long the view should animate.
     */
    public func beginFlashLoading(_ toColor : UIColor, fromColor: UIColor, duration:Double) {
        let flashColor = CABasicAnimation()
        flashColor.keyPath = "backgroundColor"
        flashColor.fromValue = fromColor.cgColor
        flashColor.toValue = toColor.cgColor
        flashColor.duration = CFTimeInterval(duration)
        flashColor.repeatCount = Float.infinity
        flashColor.autoreverses = true
        flashColor.beginTime = CACurrentMediaTime() + CFTimeInterval(0)
        self.layer.add(flashColor, forKey: "flash")
    }
    
    /**
     This method will cancel the flashing animation.
     */
    public func cancelFlashLoading() {
        self.layer.removeAnimation(forKey: "flash")
        
    }
}


extension UIView : Flashable {}
