//
//  UIColor+Extension.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/28/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import UIKit
import Foundation

public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    convenience init(grayLevel: Int, alpha: CGFloat = 1) {
        self.init(white: CGFloat(grayLevel) / 255.0, alpha: alpha)
    }
    convenience init(hex:Int, alpha: CGFloat = 1) {
        self.init(red:CGFloat((hex >> 16) & 0xff)/255.0, green:CGFloat((hex >> 8) & 0xff)/255.0, blue:CGFloat(hex & 0xff)/255.0, alpha:alpha)
    }
    
    convenience init(hexValue: String) {
        let hex = hexValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}

public extension UIColor {
    static let blueLightColor: UIColor = UIColor(hex: 0x1BA8FF)
}
