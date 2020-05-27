//
//  UIImage+Extension.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    var pngRepresentationData: Data? {
        return UIImagePNGRepresentation(self)
    }

    var jpegRepresentationData: Data? {
        return UIImageJPEGRepresentation(self, 1.0)
    }
}
