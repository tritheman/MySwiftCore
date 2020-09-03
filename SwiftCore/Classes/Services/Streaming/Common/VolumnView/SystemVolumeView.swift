//
//  SystemVolumeView.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 7/13/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import MediaPlayer

class SystemVolumeView: MPVolumeView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let volumeThumbInactiveImage = UIImage(named: "volume-scrubber-inactive", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let volumeThumbPressImage = UIImage(named: "volume-scrubber-press", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        self.setVolumeThumbImage(volumeThumbInactiveImage, for: .normal)
        self.setVolumeThumbImage(volumeThumbPressImage, for: .highlighted)
    }
    
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.volumeSliderRect(forBounds: bounds)
        newBounds.origin.y = bounds.origin.y
        newBounds.size.height = bounds.size.height
        return newBounds
    }
    
    override func routeButtonRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.routeButtonRect(forBounds: bounds)
        newBounds.origin.y = bounds.origin.y
        newBounds.size.height = bounds.size.height
        return newBounds
    }
}
