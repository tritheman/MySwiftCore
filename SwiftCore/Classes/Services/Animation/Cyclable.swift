//
//  Cyclable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol Cyclable { }
public extension  Cyclable where Self:UILabel {
    func cycleText(_ message : String?, firstCycle : Bool) {
        func initialCycling(){
            let startFrame = self.frame.offsetBy(dx: 0, dy: 25)
            let endFrame = self.frame
            self.alpha = 0
            self.frame = startFrame
            UIView.animate(withDuration: 1.5, delay:0, options: [], animations: {
                self.frame = endFrame
                self.alpha = 1
            }, completion: nil)
        }
        //First cycle moves the label from bottom to top along with text fading.
        if firstCycle {
            self.text = message
            initialCycling()
        }
        else {
            //Subsequent cycles will move the label from top to bottom and bottom to top along with text fading.
            //Once all animations are done, Incredibles who own animations will re-factor and move all the constants in a central location.
            let originalFrame = self.frame
            let endFrame = self.frame.offsetBy(dx: 0, dy: 25)
            self.alpha = 1
            UIView.animate(withDuration: 1.0, delay:0, options: [], animations: {
                self.frame = endFrame
                self.alpha = 0
            }, completion: { (finished) in
                if finished {
                    self.frame = originalFrame
                    self.text = message
                    initialCycling()
                }
            })
        }
    }
}
extension UILabel: Cyclable{}
