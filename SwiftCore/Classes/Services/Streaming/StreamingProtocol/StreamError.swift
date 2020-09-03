//
//  PlayerError.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/19/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation

public enum StreamError: Error {
    case unknown(String)
    case startupFailed
    case authorizationError
    case bufferingTimeout
    case loadPlaybackError
    case licenseExpired
    
    var message: String? {
        switch self {
        case .unknown(let message):
            return message
        default:
            return "Sample Error"
        }
    }
}
