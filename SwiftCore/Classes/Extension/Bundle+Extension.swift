//
//  Bundle+Extension.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//

import Foundation

extension Bundle {
    
    public var shortVersion : String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var name: String? {
        return self.infoDictionary?["CFBundleName"] as? String 
    }
    
    public var version : String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
    //Full version includes version number along with build number
    public func getFullVersion() -> String? {
        guard let appVer = shortVersion, let buildString = version, let buildNumber = Int( buildString)  else { return shortVersion }
        return appVer.components(separatedBy: ".").count < 3 ? String(format: "%@.0.%d", appVer, buildNumber) : String(format: "%@.%d", appVer, buildNumber)
    }
    
    public var bundleID: String {
        var bundleID : String = "bundleId-unknown"
        if let bundleDictionary = Bundle.main.infoDictionary, let appBundleID = bundleDictionary[String(kCFBundleIdentifierKey)] as? String {
            bundleID = appBundleID
        }
        return bundleID
    }
    
    public var displayName: String {
        var displayName : String = "displayName-unknown"
        if let bundleDictionary = Bundle.main.infoDictionary, let appName = bundleDictionary["CFBundleDisplayName"] as? String {
            displayName = appName
        }
        return displayName
    }
    
    public var applicationVersion: String {
        var version : String = "version-unknown"
        if let appVersion = Bundle.main.shortVersion {
            version = appVersion
        }
        return version
    }
}
