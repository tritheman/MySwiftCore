//
//  CacheCodable+Default.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 4/9/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

extension Data {
    func subrangeToEnd(withOffset offset: Int) -> Data {
        return self[self.startIndex.advanced(by: offset)...]
    }
}

extension String: CacheCodable { }
extension Int: CacheCodable { }
extension Int64: CacheCodable { }
extension UInt: CacheCodable { }
extension UInt64: CacheCodable { }
extension Float: CacheCodable { }
extension Double: CacheCodable { }
extension Date: CacheCodable { }
extension Bool: CacheCodable { }
extension Data: CacheCodable { }

extension Array: CacheEncodable where Element: CacheEncodable {
    public func toData() throws -> Data {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        return encodedData
    }
    
}

extension Array: CacheDecodable where Element: CacheDecodable {
    public static func initialize(fromCache data: Data) throws -> Array<Element> {
        if let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Element] {
            return decodedArray
        }
        return []
    }
}

extension Dictionary: CacheEncodable where Key: CacheEncodable, Value: CacheEncodable {
    public func toData() throws -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData
        } catch {
            throw CacheError.encodeError
        }
    }
    
}

extension Dictionary: CacheDecodable where Key: CacheDecodable, Value: CacheDecodable  {
    public static func initialize(fromCache data: Data) throws -> Dictionary<Key, Value> {
        do {
            let decoded = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictFromJSON = decoded as? Dictionary<Key, Value> {
                return dictFromJSON
            }
            return [:]
        } catch {
            throw CacheError.encodeError
        }
    }
}

