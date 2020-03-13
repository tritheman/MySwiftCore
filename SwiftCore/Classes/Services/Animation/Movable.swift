//
//  Movable.swift
//  Motion
//
//  Created by Salinas, Eduardo on 9/20/16.
//  Copyright © 2016 ATT. All rights reserved.
//

import Foundation

/**
 This protocol defines the properties and methods for any object that wishes to show an animation while moving its position.
 */
public protocol Movable { }

extension Movable where Self : UIImageView {
  
  /**
   This method creates a frame offset on an imageView. Used for the Parallax animation.
   - parameter offset: The  point based on the view's frame from which to offset the frame. Specify an offset of (0, 0) to return the view to its original position.
   */
  public func motionOffset(offset : CGPoint) {
    self.frame = self.bounds.offsetBy(dx: offset.x, dy: offset.y)
  }
}

extension Movable where Self : UIView {
  
  /**
   This method animates a movement of a view, from the starting to the end. The timing function used is EaseOut.
   - parameter startOffset: The starting point based on the view's frame from which to start the animation. Specify a startOffset of (0, 0) to start the transition from the view's current position.
   - parameter endOffset: The end point based on the view's frame from which to end the animation.
   - parameter duration: The duration of the animation.
   - parameter delay: The delay in seconds for the animation to start.
   - parameter completionHandler: An optional closure to execute once the animation is done.
   */
  public func motionMove(_ startOffset : CGPoint, endOffset : CGPoint, duration : Double, delay : Double, completionHandler : (() -> ())? = nil) {
    
    // NOTE: Because the view can have constraints attached to it, we need to use transforms to move the view. If we try to set the frame, the constraints will force it into place, and passing the constraint as a parameter would mean that users would have to create outlets or references to several constraints for it to work.
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
