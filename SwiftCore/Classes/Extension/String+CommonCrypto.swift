//
//  String+CommonCrypto.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/7/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {

    public var sha1: String? {
        guard let input = self.data(using: .utf8) else {
            return nil
        }

        let hash = input.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            CC_SHA1(bytes.baseAddress, CC_LONG(input.count), &hash)
            return hash
        }

        return hash.map({ String(format: "%02x", $0) }).joined()
    }
    
    public func hashed(_ type: HashType, output: HashOutputType = .hex) -> String? {
        guard let message = data(using: .utf8) else { return nil }
        return message.hashed(type, output: output)
    }
    
}

extension Data {
    public func hashWithRSA2048Asn1Header(_ type: HashType, output: HashOutputType = .hex) -> String? {
        
        let rsa2048Asn1Header:[UInt8] = [
            0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
            0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
        ]
        
        var headerData = Data(bytes: rsa2048Asn1Header)
        headerData.append(self)
        
        return hashed(type, output: output)
    }
    
    public func hashed(_ type: HashType, output: HashOutputType = .hex) -> String? {
        
        // setup data variable to hold hashed value
        var digest = Data(count: Int(type.length))
        
        // generate hash using specified hash type
        _ = digest.withUnsafeMutableBytes { (digestBytes: UnsafeMutablePointer<UInt8>) in
            self.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                let length = CC_LONG(self.count)
                switch type {
                case .md5: CC_MD5(messageBytes, length, digestBytes)
                case .sha1: CC_SHA1(messageBytes, length, digestBytes)
                case .sha224: CC_SHA224(messageBytes, length, digestBytes)
                case .sha256: CC_SHA256(messageBytes, length, digestBytes)
                case .sha384: CC_SHA384(messageBytes, length, digestBytes)
                case .sha512: CC_SHA512(messageBytes, length, digestBytes)
                }
            }
        }
        
        // return the value based on the specified output type.
        switch output {
        case .hex: return digest.map { String(format: "%02hhx", $0) }.joined()
        case .base64: return digest.base64EncodedString()
        }
    }
}
