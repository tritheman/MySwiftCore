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
    static let Cerulean = UIColor(r: 0, g: 159, b: 219)
    static let Cyan = UIColor(r: 35, g: 209, b: 207)
    
    static let MacaroniAndCheese = UIColor(r: 246, g: 178, b: 64)
    
    static let Seaweed: UIColor = UIColor(r: 24, g: 190, b: 135)
    
    static let playerBackgroundImageTintBlue: UIColor = UIColor(red: 0.2, green: 0.65, blue: 0.9, alpha: 1.0)
    
    static let popupLinkTextBlue: UIColor = UIColor(r: 0, g: 178, b:  237)
    
    static let activeCastingTextColor: UIColor = UIColor(r: 19, g: 102, b: 255)
    
    static let White20: UIColor = UIColor(r: 250, g: 250, b: 250)
    
    static let White: UIColor = UIColor(r: 235, g: 235, b: 235)
    
    static let LightGray: UIColor = UIColor(r: 218, g: 218, b: 218)
    
    static let Gray190: UIColor = UIColor(r: 190, g: 190, b: 190)
    
    static let Gray192: UIColor = UIColor(r: 192, g: 192, b: 192)
    
    static let Gray155: UIColor = UIColor(r: 155, g: 155, b: 155)
    
    static let Gray74: UIColor = UIColor(r: 74, g: 74, b: 74)
    
    static let Gray40: UIColor = UIColor(r: 40, g: 40, b: 40)
    
    static let Gray34: UIColor = UIColor(r: 34, g: 34, b: 34, a: 0.6)
    
    static let Black34: UIColor = UIColor(r: 34, g: 34, b: 34)
    
    static let Black31: UIColor = UIColor(r: 31, g: 31, b:  31)
    
    static let WarmGray: UIColor = UIColor(r: 128, g: 128, b: 128)
    
    static let FilterIndicator: UIColor = UIColor(r: 0, g: 178, b:  237)
    
    static let FocusedColor: UIColor = UIColor(r: 0, g: 159, b:  219)
    
    static let TooltipBackgroundColor: UIColor = UIColor(r: 36, g: 133, b: 188)
    static let blueLightColor: UIColor = UIColor(hex: 0x1BA8FF)
}
