//
//  NSAttributedString+Extension.swift
//  BaseApplication
//
//  Created by Dang Huu Tri on 5/4/19.
//  Copyright © 2019 Dang Huu Tri. All rights reserved.
//

import Foundation
import UIKit


extension NSMutableAttributedString {
    
    @discardableResult func appEndBold(_ text:String) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func appEndBold(_ text:String, color: UIColor, size:CGFloat) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor: color]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func appEndColor(text:String, color: UIColor, fontsize: CGFloat = 16) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontsize), NSAttributedString.Key.foregroundColor: color]
        let coloredString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(coloredString)
        return self
    }
    
    @discardableResult func normal(_ text:String) -> NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
    
    func attributedStringWithImages(images:UIImage..., offset: CGPoint = CGPoint(x: 0, y: 0)) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        for image in images {
            let textAttachment = NSTextAttachment()
            textAttachment.image = image
            textAttachment.bounds = CGRect(x: offset.x, y: offset.y, width: image.size.width, height: image.size.height)
            let imageAttributedString = NSAttributedString(attachment: textAttachment)
            attributedString.append(imageAttributedString)
        }
        return attributedString
    }
}

extension NSAttributedString {
    typealias ReplacementData = (replaceWith: String, image: UIImage, iconBound: CGRect)
    
    func attributedString(with dataItems: ReplacementData...) -> NSMutableAttributedString {
        let mutableAttributedString = mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        
        for item in dataItems {
            while mutableString.contains(item.replaceWith) {
                let rangeOfStringToBeReplaced = mutableString.range(of: item.replaceWith)
                
                let textAttachment = NSTextAttachment()
                textAttachment.image = item.image
                
                textAttachment.bounds = CGRect(x: item.iconBound.origin.x, y: item.iconBound.origin.y, width: item.iconBound.size.width, height: item.iconBound.size.height)
                let imageAttributedString = NSAttributedString(attachment: textAttachment)
                
                mutableAttributedString.replaceCharacters(in: rangeOfStringToBeReplaced, with: imageAttributedString)
            }
        }
        
        return mutableAttributedString
    }
    
    func attributedString(contentString:NSAttributedString, newLine: Bool = false) -> NSMutableAttributedString {
        let resultString = NSMutableAttributedString(string: "")
        if newLine {
            if self.length > 0 {
                resultString.append(NSAttributedString(string: "\n"))
            }
        }
        resultString.append(contentString)
        return resultString
    }
}
