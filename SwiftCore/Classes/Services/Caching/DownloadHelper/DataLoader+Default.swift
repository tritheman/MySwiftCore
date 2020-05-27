//
//  DataLoader+Default.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public extension DataLoader {
    
    static let cachePath: String = {
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        if let cachePath = cachePaths.first, let identifier = Bundle.main.bundleIdentifier {
            return cachePath.appending("/" + identifier)
        }
        return ""
    }()
    
    static var defaultConfiguration: URLSessionConfiguration {
        let conf = URLSessionConfiguration.default
        conf.urlCache = DataLoader.sharedUrlCache
        return conf
    }
    
    static let sharedUrlCache: URLCache = {
        let diskCapacity = 150 * 1024 * 1024 // 150 MB
        print("tridh 2 cache path \(cachePath)")
        return URLCache(memoryCapacity: 0, diskCapacity: diskCapacity, diskPath: cachePath)
    }()
    
    static func validate(response: URLResponse) -> DataLoaderError? {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }
        return (200..<300).contains(response.statusCode) ? nil : DataLoaderError.statusCodeUnacceptable(response.statusCode)
    }
}
