//
//  UIStackView+Utility.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//


import UIKit

public extension UIStackView {

    open func setArrangedSubviews(_ arrangedSubviews: [UIView]) {
        
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for view in arrangedSubviews {
            self.addArrangedSubview(view)
        }
    }
}
