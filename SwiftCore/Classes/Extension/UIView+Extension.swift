//
//  UIView+Extension.swift
//  LoanRegister
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func border(width:CGFloat, color: UIColor, radius: CGFloat?) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        if let radius = radius {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
    
    func border(width:CGFloat, color: UIColor) {
        self.border(width: width, color: color, radius: nil)
    }
}
