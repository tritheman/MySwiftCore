//
//  CacheCodable.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 4/9/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public protocol CacheEncodable {
    func toData() throws -> Data
}

public protocol CacheDecodable {
    static func initialize(fromCache data: Data) throws -> Self
}

//public typealias CacheCodable = CacheEncodable & CacheDecodable
public protocol CacheCodable: CacheEncodable, CacheDecodable {
    var codableClassName: String { get }
}

public extension CacheCodable {
    var codableClassName: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }
}

extension CacheEncodable where Self: Encodable {
    public func toData() throws -> Data {
        do {
            let user = try JSONEncoder().encode(self)
            return user
        } catch {
            throw CacheError.encodeError
        }
    }
}

extension CacheEncodable where Self: Decodable {
    public static func initialize(fromCache data: Data) throws -> Self {
        do {
            let value = try JSONDecoder().decode(Self.self, from: data)
            return value
        } catch {
            throw CacheError.encodeError
        }
    }
}
