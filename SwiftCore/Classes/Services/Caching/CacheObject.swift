//
//  CacheObjectWrapper.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 4/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

//public struct CacheObject<T: CacheCodable> {
//    public let value: T
//
//    init(_ newValue: T) {
//        value = newValue
//    }
//}

public struct CacheObject:Codable, CacheCodable {

    public let value: Data?
    public let codableClassName: String


    init(_ newValue: CacheCodable) {
        value = try? newValue.toData()
        codableClassName = newValue.codableClassName
    }
}

//extension CacheObject: CacheCodable {
//    public func toData() throws -> Data {
//        do {
//            let data = try value.toData()
//            return data
//        } catch {
//            throw CacheError.encodeError
//        }
//    }
//
//    public static func initialize(fromCache data: Data) throws -> CacheObject {
//        do {
//            let object = try T.initialize(fromCache: data)
//            return CacheObject(object)
//        } catch {
//            throw CacheError.decodeError
//        }
//    }
//}

//let className = decodedObj.encodedName ?? ""
//guard let thisClassName = NSClassFromString(className) as? CacheCodable.Type, let objectValue = decodedObj.value else {
//    return nil
//}
//let object = try thisClassName.initialize(fromCache: objectValue)
//return object
