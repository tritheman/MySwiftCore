//
//  IdentifiableType.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public protocol IdentifiableType {
    associatedtype Identity: Hashable

    var identity : Identity { get }
}
