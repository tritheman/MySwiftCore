//
//  UIViewController+Extension.swift
//  BaseApplication
//
//  Created by Dang Huu Tri on 1/21/20.
//  Copyright © 2020 Dang Huu Tri. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
