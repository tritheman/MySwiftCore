//
//  FileNameHashUtils.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/7/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CommonCrypto

public typealias FilenameGenerator = (_ key: String) -> String?

public enum HashOutputType {
    case hex
    case base64
}

public enum HashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
    
    public var generator: FilenameGenerator {
        return { (key) -> String? in
            return key.hashed(self, output: HashOutputType.hex)
        }
    }
    
    var length: Int32 {
        switch self {
        case .md5: return CC_MD5_DIGEST_LENGTH
        case .sha1: return CC_SHA1_DIGEST_LENGTH
        case .sha224: return CC_SHA224_DIGEST_LENGTH
        case .sha256: return CC_SHA256_DIGEST_LENGTH
        case .sha384: return CC_SHA384_DIGEST_LENGTH
        case .sha512: return CC_SHA512_DIGEST_LENGTH
        }
    }
}
