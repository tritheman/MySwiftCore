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
        return self.pngData()
    }

    var jpegRepresentationData: Data? {
        return self.jpegData(compressionQuality: 1.0)
    }
}
