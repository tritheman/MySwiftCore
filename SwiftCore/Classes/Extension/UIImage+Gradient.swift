//
//  UIImage+Extension.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

///Non-gradient Tag is used to assign to UIImageView.
public let TAG_NO_GRADIENT = 0
///Gradient Tag is used to assign to UIImageView.
public let TAG_HAS_GRADIENT = 1

extension UIImage {
    
    public func getTopRightRadialGradientImage(dominantColor:UIColor) -> UIImage {
        var dominantImage = UIImage()
        
        /// unwrapping rbg and alpha values of the dominant color
        guard let dominantColorValues =  dominantColor.cgColor.components else {
            return self
        }
        /// creating a new dominant color with alpha zero. So now we fade out from dominant color with alpha zero to alpha one
        let dominantColorWithAlphaZero = UIColor(red: dominantColorValues[0], green: dominantColorValues[1], blue: dominantColorValues[2], alpha: 0)
        /// begin context
        UIGraphicsBeginImageContext(size)
        dominantImage = self
        dominantImage.draw(in: CGRect(x:0,y:0, width: size.width, height: size.height))
        
        /// current graphics context
        let context = UIGraphicsGetCurrentContext()
        //// Gradient Declarations
        let gradient = CGGradient(colorsSpace: nil, colors: [dominantColorWithAlphaZero.cgColor,dominantColor.cgColor] as CFArray, locations: [0.3,1.0])!
        let startRadius:CGFloat = 0
        let widthRadius = size.width * size.width
        let heightRadius = size.height * size.height
        let sumOfRadius = widthRadius + heightRadius
        let endRadius = sumOfRadius.squareRoot() / 2 * 0.99
        let startPoint = CGPoint(x:size.width - (endRadius / 2 ), y:0)
        
        context?.saveGState()
        /// drawing radial gradient
        context?.drawRadialGradient(gradient, startCenter: startPoint, startRadius: startRadius, endCenter: startPoint, endRadius: endRadius, options: .drawsAfterEndLocation)
        context?.restoreGState()
        
        /// getting the image with dominant color from current context
        dominantImage = UIGraphicsGetImageFromCurrentImageContext()!
        /// return the image with dominant color on it
        return dominantImage
    }
    
    public func getLinearGradientImage(dominantColor: UIColor) -> UIImage {
        var dominantImage = UIImage()
        
        guard let dominantColorValues =  dominantColor.cgColor.components else {
            return self
        }
        /// creating a new dominant color with alpha zero. So now we fade out from dominant color with alpha zero to alpha one
        let dominantColorWithAlphaZero = UIColor(red: dominantColorValues[0], green: dominantColorValues[1], blue: dominantColorValues[2], alpha: 0)
        /// begin context
        UIGraphicsBeginImageContext(size)
        dominantImage = self
        dominantImage.draw(in: CGRect(x:0,y:0, width: size.width, height: size.height))
        
        /// current graphics context
        let context = UIGraphicsGetCurrentContext()
        /// Gradient Declarations, filling gradient with dominant color with alpha zero to alpha 1
        let gradient = CGGradient(colorsSpace: nil, colors: [dominantColor.cgColor, dominantColorWithAlphaZero.cgColor] as CFArray, locations: [0,1])!
        context?.saveGState()
        /// draw linear gradient
        context?.drawLinearGradient(gradient,start: CGPoint(x: 0, y: size.height),end: CGPoint(x: 0, y: size.height/2),options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        context?.restoreGState()
        
        /// getting the image with dominant color from current context
        dominantImage = UIGraphicsGetImageFromCurrentImageContext()!
        /// return the image with dominant color on it
        return dominantImage
    }
    
    public func getLinearGradientImage(_ imageSize: CGSize, gradientLength: CGFloat? = nil) -> UIImage {
        if UIDevice.current.userInterfaceIdiom == .tv {
            //The values is asked by UI/UX team.
            return getLinearGradientForSize(imageSize, colors: [UIColor.black.withAlphaComponent(0.95).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.black.withAlphaComponent(0).cgColor], locations: [0,0.35,1], gradientLength: gradientLength ?? 120)
        } else {
            //The values is asked by UI/UX team.
            return getLinearGradientForSize(imageSize, colors: [UIColor.black.withAlphaComponent(0.85).cgColor, UIColor.black.withAlphaComponent(0.65).cgColor, UIColor.black.withAlphaComponent(0).cgColor], locations: [0,0.5,1], gradientLength: gradientLength ?? 95)
        }
    }
    
    /// used for showing gradient on smaller images(used in tvgeneric carousel)
    private func getLinearGradientForSize(_ imageSize: CGSize, colors: [CGColor], locations:[CGFloat], gradientLength: CGFloat,  repetition : Int = 0) -> UIImage {
        guard repetition >= 0 else { return self }
        //Use the actual image's size, then the render image won't be pixelated
        let widthInPoints = self.size.width
        let imageWidthInPixel = widthInPoints * self.scale
        let heightInPoints = self.size.height
        let imageHeightInPixel = heightInPoints * self.scale
        let gradientScale = imageHeightInPixel / imageSize.height
        let gradientLengthInPixel = imageHeightInPixel - (gradientLength * gradientScale)
        
        var dominantImage = UIImage()
        dominantImage = self
        
        UIGraphicsBeginImageContext(CGSize(width:imageWidthInPixel,height:imageHeightInPixel))
        dominantImage.draw(in: CGRect(x:0,y:0, width: imageWidthInPixel, height: imageHeightInPixel))
        
        /// current graphics context
        let context = UIGraphicsGetCurrentContext()
        /// Gradient Declarations, filling gradient with dominant color
        let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: locations)!
        context?.saveGState()
        for _ in 0..<(repetition+1) {
            /// draw linear gradient
            context?.drawLinearGradient(gradient,start: CGPoint(x: 0, y: imageHeightInPixel),end: CGPoint(x: 0, y: gradientLengthInPixel),options: [.drawsBeforeStartLocation,.drawsAfterEndLocation])
        }
        context?.restoreGState()
        
        /// getting the image with dominant color from current context
        dominantImage = UIGraphicsGetImageFromCurrentImageContext()!
        /// return the image with dominant color on it
        return dominantImage
    }
    
}
