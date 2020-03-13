//
//  DateFormatter.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/27/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    class func dateFormaterStyleYYYYMMDD() -> DateFormatter {
        return DateFormatter.dateFormater("yyyy-MM-dd")
    }
    
    class func dateFormater(_ style: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = style
        return dateFormatter
    }
}
