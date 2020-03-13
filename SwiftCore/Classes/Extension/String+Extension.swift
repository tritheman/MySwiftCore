//
//  String+Extension.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/29/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import Foundation

extension String {
    static func formatHHMM(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(seconds))!
    }
}
