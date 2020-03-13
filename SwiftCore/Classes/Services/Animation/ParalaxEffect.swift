//
//  ParalaxEffect.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

/**
 This protocol defines the properties and methods for any object that wishes to show a parallax effect while scrolling.
 */
public protocol Parallaxable : Movable { }

public extension Parallaxable where Self : UIImageView {
    
    /**
     This method animates a movement of an image view, creating a parallax effect. The timing function used is EaseOut. The effect is relative to the screen of the device. The parallax effect ranges to 8% of the image for all sides, according to the UI Specs.
     - parameter scale: The scale of how much should the image be displaced. Default is 0.05 (5%) as per UI Specs.
     */
    public func motionParallax(scale : CGFloat = 0.05) {
        
        let screenFrame = UIScreen.main.bounds
        let frame = self.convert(self.bounds, to:nil)
        let center = self.convert(self.center, to: nil)
        
        let xOffset = (screenFrame.origin.x - center.x / screenFrame.size.width) * (scale * frame.size.width)
        let yOffset = (screenFrame.origin.y - center.y / screenFrame.size.height) * (scale * frame.size.height)
        
        let point = CGPoint(x: xOffset, y: yOffset)
        
        self.motionOffset(offset: point)
    }
}

/*
 This extension allows for the parallax effect on the posters of the carousel cells.
 */
extension UIImageView : Parallaxable { }
