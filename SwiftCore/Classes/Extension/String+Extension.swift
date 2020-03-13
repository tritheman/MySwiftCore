//
//  String+Extension.swift
//  ShopBack
//
//  Created by Dang Huu Tri on 10/29/19.
//  Copyright © 2019 ShopBack. All rights reserved.
//

import Foundation
import UIKit

public enum TextAlignCSS: String {
    case left = "left"
    case right = "right"
    case center = "center"
    case justify = "justify"
    case none = "none"
}

public extension String {
    static func formatHHMM(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    mutating func replace(atIndex index: Int, _ newString: String) -> String {
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        self.replaceSubrange(stringIndex...stringIndex, with: newString)
        return self
    }
    
    func trimming() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func convertHtml(font: UIFont, color: String = "", textAlign: TextAlignCSS = .left) -> NSAttributedString {
        let customFontName = font.familyName
        let customFontSize = font.pointSize
        var inputText = "\(self)<style>body { font-family: '\(customFontName)'; font-size:\(customFontSize)px; color: \(color); text-align: \(textAlign); line-height: 1.3}</style>"
        if color.count == 0 {
            inputText = "\(self)<style>body { font-family: '\(customFontName)'; font-size:\(customFontSize)px; text-align: \(textAlign); line-height: 1.3}</style>"
        }
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        if let htmlData = NSString(string: inputText).data(using: String.Encoding.unicode.rawValue),
            let attributedString = try? NSMutableAttributedString(data: htmlData,
                                                                  options: options,
                                                                  documentAttributes: nil) {
            if textAlign != TextAlignCSS.none {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.3
                if textAlign == TextAlignCSS.center {
                    paragraphStyle.alignment = .center
                } else {
                    paragraphStyle.alignment = .left
                }
                
                attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                return attributedString
            }
            
            return attributedString
        }
        
        return NSAttributedString()
    }
    
    var htmlDecoded: String {
        guard let encodedData = self.data(using: .utf8) else {
            return self
        }
        
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        do {
            let attributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
            return attributedString.string
        } catch {
            print("Error: \(error)")
            return self
        }
    }
    
    func buildImageURL() -> String {
        return self.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    }
    
    func strippingHTML() -> String {
        let str = self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return str
    }
    
    func toBold() -> NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)]
        let boldString = NSMutableAttributedString(string:"\(self)", attributes:attrs)
        return boldString
    }
    func toBold(color: UIColor, size: CGFloat) -> NSMutableAttributedString {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor: color]
        return NSMutableAttributedString(string:"\(self)", attributes:attrs)
    }
    
    func appendPathComponent(_ path: String) -> String {
        return URL(string: self)?.appendingPathComponent(path).absoluteString ?? self
    }
    
    func attributedStringWithIcon(iconNames:String..., offset: CGFloat = -5) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for imageName in iconNames {
            if let image = UIImage(named: imageName) {
                let textAttachment = NSTextAttachment()
                textAttachment.image = image
                textAttachment.bounds = CGRect(x: 0, y: offset, width: image.size.width, height: image.size.height)
                let imageAttributedString = NSAttributedString(attachment: textAttachment)
                attributedString.append(imageAttributedString)
            }
        }
        return attributedString
    }
}

public extension String {
    
    func matchesRegex(_ regex: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: regex,
                                                options: .caseInsensitive) {
            let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            if results.count > 0 {
                return true
            }
        }
        
        return false
    }
    
    func isValidName() -> Bool {
        return self.range(of: "(?i)([0-9A-ZẮẰẲẴẶĂẤẦẨẪẬÂÁÀÃẢẠĐẾỀỂỄỆÊÉÈẺẼẸÍÌỈĨỊỐỒỔỖỘÔỚỜỞỠỢƠÓÒÕỎỌỨỪỬỮỰƯÚÙỦŨỤÝỲỶỸỴ'.,/]+\\s?\\b){2,}", options: .regularExpression) != nil
        
    }
    
    func convertToArrayDictionary() -> [[String: Any]]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(max: Int) -> String {
        let endIndex = self.index(self.startIndex, offsetBy: max)
        return String(self[..<endIndex])
    }
    
    subscript(bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript(bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        
        return String(self[start..<end])
    }
}

public extension String {
    func paraGraphLineSpacing(lineSpacing: CGFloat = 0.0,
                              lineHeightMultiple: CGFloat = 0.0,
                              textAlignment: NSTextAlignment = .center,
                              lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSMutableAttributedString {
        
        let labelText = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributedString:NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: labelText)
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}

public extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}


extension String {
    public func encodeWithXorByte(key: UInt8) -> String {
        let xorBytes = Data(bytes:self.utf8.map{$0 ^ key})
        return xorBytes.base64EncodedString(options: [])
    }
}
