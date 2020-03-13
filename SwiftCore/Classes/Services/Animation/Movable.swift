//
//  Movable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
/**
 This protocol defines the properties and methods for any object that wishes to show an animation while moving its position.
 */
public protocol Movable { }

extension Movable where Self : UIImageView {
    public func motionOffset(offset : CGPoint) {
        self.frame = self.bounds.offsetBy(dx: offset.x, dy: offset.y)
    }
}

public extension Movable where Self : UIView {
    public func motionMove(_ startOffset : CGPoint, endOffset : CGPoint, duration : Double, delay : Double, completionHandler : (() -> ())? = nil) {
        
        let startTransform = CATransform3DTranslate(layer.transform, startOffset.x, startOffset.y, 0.0)
        
        let endTransform = CATransform3DTranslate(layer.transform, endOffset.x, endOffset.y, 0.0)
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fillMode  = kCAFillModeBackwards
        animation.beginTime = CACurrentMediaTime() + delay
        animation.duration  = duration
        animation.fromValue = NSValue(caTransform3D: startTransform)
        animation.toValue   = NSValue(caTransform3D: endTransform)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        self.layer.transform = endTransform
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completionHandler?()
        })
        layer.add(animation, forKey: "transform")
        CATransaction.commit()
        
    }
}
