//
//  NSData+Hash.swift
//  BaseApplication
//
//  Created by Dang Huu Tri on 5/3/19.
//  Copyright © 2019 Dang Huu Tri. All rights reserved.
//

import Foundation
import CommonCrypto

public class SHA256HashUtil {
    public init() { }
    
    public func getSHA256(input: NSData) -> String {
        return hexStringFromData(input: digest(input: input))
    }
    
    fileprivate func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    fileprivate func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}


extension NSData {
    public func sha256hash() -> String {
        let util = SHA256HashUtil()
        return util.getSHA256(input: self)
    }
}
