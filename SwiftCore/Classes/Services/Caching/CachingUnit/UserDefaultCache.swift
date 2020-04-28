//
//  UserDefaultCache.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 4/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class UserDefaultCache: DiskAppCache {
    
    fileprivate var cacheQueue = DispatchQueue(label: "UserDefaultCache Queue", attributes: DispatchQueue.Attributes.concurrent)
    
    var cachedUserDefault = [String : CacheCodable]()
    
    init() {
        loadCacheFromDisk()
    }
    
    public var isEmpty: Bool {
        return cachedUserDefault.isEmpty
    }
    
    public func hasKey(_ key: String) -> Bool {
        return (cachedUserDefault.index(forKey: key) != nil)
    }
    
    public func getKeys() -> [String] {
        return Array(cachedUserDefault.keys)
    }
    
    public func setObject(_ object: CacheCodable, forKey key: String) {
        cacheQueue.async(flags: DispatchWorkItemFlags.barrier) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.cachedUserDefault[key] = object
        }
    }
    
    public func getObject(_ key: String) -> CacheCodable? {
        return cachedUserDefault[key]
    }
    
    public func removeObject(_ key: String) {
        cachedUserDefault.removeValue(forKey: key)
    }
    
    public func saveToDisk() {
        for key in cachedUserDefault.keys {
            if let object = cachedUserDefault[key] {
                let cachedObject = CacheObject(object)
                if let archivedObject = try? cachedObject.toData() {
                    UserDefaults.standard.set(archivedObject, forKey: key)
                }
            }
        }
    }
    
    public func loadCacheFromDisk() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if let unarchivedObject = UserDefaults.standard.object(forKey: key) as? Data  {
                let curCacheObject = try? CacheObject.initialize(fromCache: unarchivedObject)
                let className = curCacheObject?.codableClassName ?? ""
                
                let thisClassName = NSClassFromString(className) as? CacheCodable.Type
                guard let objectValue = curCacheObject?.value, let curClassName = thisClassName else {
                    continue
                }
                
                if let object = try? curClassName.initialize(fromCache: objectValue) {
                    cachedUserDefault[key] = object
                }
            }
        }
    }
    
    public func getObjectFromDisk(_ key: String) -> CacheCodable? {
        return nil
    }
    
    public func clear() {
        cachedUserDefault.removeAll()
    }
    
    
}
