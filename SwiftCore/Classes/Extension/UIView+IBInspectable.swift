//
//  UIView+IBInspectable.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//


import UIKit

@IBDesignable
public extension UIView {
    
    @IBInspectable open var borderWidth: CGFloat {
        
        get {
            
            return self.layer.borderWidth
        }
        set {
            
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        
        get {
            
            guard let cgColor = self.layer.borderColor else {
                return nil
            }
            
            return UIColor(cgColor: cgColor)
        }
        set {
            
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat {
        
        get {
            
            return self.layer.cornerRadius
        }
        set {
            
            self.layer.cornerRadius = newValue
        }
    }
}
