//
//  UIButton+Extensions.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//


import UIKit

extension UIButton {
    
    func increseTapArea(top: CGFloat = 5, left: CGFloat = 5, bottom: CGFloat = 5, right: CGFloat = 5) {
        self.contentEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
}
