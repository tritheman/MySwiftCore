//
//  CurrentTimeLabel.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 1/21/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import UIKit

class CurrentTimeLabel: UILabel {
    private var timer: Timer!   // Created in setupTimer() called from all initializers.
    
    private static let formatter = createFormatter()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        updateTime()    // Set label text for the first time
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common) //update the timer while tracking
    }
    
    @objc private func updateTime() {
        text = CurrentTimeLabel.formatter.string(from: Date())
    }
    
    private static func createFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        // TODO: Localization?...
        formatter.amSymbol = "a"
        formatter.pmSymbol = "p"
        return formatter
    }
}
