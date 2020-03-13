//
//  Date+Extension.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/27/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func toDateString() -> String {
        return DateFormatter.dateFormaterStyleYYYYMMDD().string(from: self)
    }
    
    static func initFromString(_ stringDate: String, withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: stringDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return calendar.date(from:components)
    }
    
    static func initFromString(_ stringDate: String) -> Date? {
        return Date.initFromString(stringDate, withFormat: "yyyy-MM-dd")
    }
}
