//
//  CacheProtocol.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 4/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation


public protocol AppCache {
    var isEmpty: Bool { get }
    func hasKey(_ key: String) -> Bool
    func getKeys() -> [String]
    func setObject(_ object: CacheCodable, forKey key: String)
    func getObject(_ key: String) -> CacheCodable?
    func removeObject(_ key: String)
    func clear()
}

extension AppCache {
  public func removeObjects(keys: [String]) {
    for key in keys {
      removeObject(key)
    }
  }
}

public protocol DiskAppCache: AppCache {
  func saveToDisk()
  func loadCacheFromDisk()
  func getObjectFromDisk(_ key: String) -> CacheCodable?
}
