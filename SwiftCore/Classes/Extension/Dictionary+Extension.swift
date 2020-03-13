//
//  Dictionary+Extension.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//


import Foundation
import UIKit
import CoreFoundation

public extension Dictionary {
  
  mutating func merge(with dictionary: Dictionary) {
    dictionary.forEach { updateValue($1, forKey: $0) }
  }
  
  func merged(with dictionary: Dictionary) -> Dictionary {
    var dict = self
    dict.merge(with: dictionary)
    return dict
  }
  
  mutating func deepMerge(with dictionary: Dictionary) {
    for (key, value) in dictionary {
      if var destDict = self[key] as? Dictionary, let sourceDict = value as? Dictionary {
        destDict.deepMerge(with: sourceDict)
        self[key] = destDict as? Value
      }
      else {
        self[key] = value
      }
    }
  }
  
  func findValueFor(caseInsensitiveKey: String) -> Any? {
    guard let key = caseInsensitiveKey as? Key else {
      return nil
    }
    if let value = self[key] {
      return value
    }
    
    return self.first { (key, value) -> Bool in
      return (key as? String)?.lowercased() == caseInsensitiveKey.lowercased()
      }?.value
  }
}

extension Dictionary  {
  public func lookUpValue(forKeys keys : Array<Any>) -> Any? {
    var arrayOfKeys = keys
    let key = arrayOfKeys.remove(at: 0)
    if let element = key as? Key {
      if(arrayOfKeys.count == 0) {
        return self[element]
      }
      if let newDict = self[element] as? Dictionary<AnyHashable,Any> {
        return newDict.lookUpValue(forKeys : arrayOfKeys)
      }
    }
    return nil
  }
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
  
  fileprivate func getValueFrom(key keyString: String)-> AnyObject? {
    let key = keyString as! Key
    if (self.index(forKey: key) != nil) {
      return self[key]
    }
    return nil
  }
  
  func getIntFrom(key keyString: String)-> Int? {
    guard let value = self.getValueFrom(key: keyString) else {
      return nil
    }
    if (value is Int ) {
      return (value as? Int)
    }
    return nil
  }
  
  func getInt64From(key keyString: String)-> Int64? {
    if let value = getIntFrom(key: keyString){
      return Int64(value)
    }
    return nil
  }
  
  func getBoolFrom(key keyString: String)-> Bool? {
    guard let value = self.getValueFrom(key: keyString) else {
      return nil
    }
    if (value is Bool ) {
      return (value as? Bool)
    }
    return  nil
  }
  
  func getStringFrom(key keyString: String)-> String? {
    guard let value = self.getValueFrom(key: keyString) else {
      return nil
    }
    if (value is String ) {
      return (value as!  String)
    }
    return nil
    
  }
  func getDictionaryFrom(key keyString: String)-> Dictionary <String, AnyObject>? {
    guard let value = self.getValueFrom(key: keyString) else {
      return nil
    }
    if (value is Dictionary <String, AnyObject> ) {
      return (value as!  Dictionary <String, AnyObject>)
    }
    return nil
  }
}
