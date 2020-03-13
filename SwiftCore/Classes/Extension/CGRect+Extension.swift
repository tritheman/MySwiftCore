//
//  CGRect+Extension.swift
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//


import Foundation
import CoreFoundation
import UIKit

extension CGRect {
  
  public var center       : CGPoint { return CGPoint(x: self.midX, y: self.midY) }
  public var topLeft      : CGPoint { return CGPoint(x: self.minX, y: self.minY) }
  public var topRight     : CGPoint { return CGPoint(x: self.maxX, y: self.minY) }
  public var bottomLeft   : CGPoint { return CGPoint(x: self.minX, y: self.maxY) }
  public var bottomRight  : CGPoint { return CGPoint(x: self.maxX, y: self.maxY) }
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
