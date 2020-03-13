//
//  UILabel+Extension.swift
//  Core
//
//  Created by TriDH on 9/10/18.
//  Copyright © 2018 TriDH. All rights reserved.
//

import UIKit

public extension UILabel {
    
    func getLabelSize() -> CGSize {
        
        if let string = self.text {
            
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: self.font],
                context: nil).size
            
            return size
        }
        
        return CGSize.zero
    }
    
    func isTruncated() -> Bool {
        
        let size = getLabelSize()
        return (size.height > self.bounds.size.height)
    }
    
    func heightForLabel() -> CGFloat {
        
        let size = getLabelSize()
        return size.height
    }
    
    func numberOfVisibleLines() -> Int {
        
        let height = Int(heightForLabel())
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = height/charSize
        
        return lineCount
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, textAlignment: NSTextAlignment = .center) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
