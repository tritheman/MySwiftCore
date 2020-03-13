//
//  Float+Extension.swift
//  LoanRegister
//
//  Created by TriDH on 9/9/18.
//  Copyright © 2018 TriDH. All rights reserved.
//

import Foundation


protocol NumberCurrencyProtocol {
    func toVND() -> String
    func stringValue() -> String
}

extension Float: NumberCurrencyProtocol {
    func toVND() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        let number = NSNumber(value: self)
        if let currencyString = formatter.string(from: number) {
            return currencyString
        }
        return ""
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func stringValue() -> String {
        return NSNumber(value: self ).stringValue
    }
}

extension Int: NumberCurrencyProtocol {
    func toVND() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        let number = NSNumber(value: self)
        if let currencyString = formatter.string(from: number) {
            return currencyString
        }
        return ""
    }
    
    func stringValue() -> String {
        return NSNumber(value: self ).stringValue
    }
}

extension Double: NumberCurrencyProtocol {
    func toVND() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        let number = NSNumber(value: self)
        if let currencyString = formatter.string(from: number) {
            return currencyString
        }
        return ""
    }
    
    func stringValue() -> String {
        return NSNumber(value: self ).stringValue
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}
