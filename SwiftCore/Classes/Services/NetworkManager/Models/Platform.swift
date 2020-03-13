//
//  Platform.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public struct Platform {
  public static let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
      isSim = true
    #endif
    return isSim
  }()
}
