//
//  ScrubberTrackView.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 1/21/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit

fileprivate let defaultPodMarkWidth:CGFloat = 4.0

struct AdPodPosition {
    var start:Float = 0
    var podMarkWidth:CGFloat = defaultPodMarkWidth
    
    init(_ start: Float, widthInPoints: CGFloat = defaultPodMarkWidth) {
        self.start = start
        self.podMarkWidth = widthInPoints
    }
}

let defaultBufferTrackTintColor = UIColor.lightGray
let defaultTrackTintColor = UIColor.darkGray
let defaultProgressTintColor = UIColor.blue


class ScrubberTrackView: UIView {
    
    var trackTintColor: UIColor = defaultTrackTintColor {
        didSet {
            setNeedsDisplay()
        }
    }
    var bufferTrackTintColor: UIColor = defaultBufferTrackTintColor {
        didSet {
            setNeedsDisplay()
        }
    }
    var progressTintColor : UIColor = defaultProgressTintColor {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var progress:Float = 0.0 { //normalized,0 to 1
        didSet {
            setNeedsDisplay()
        }
    }
    
    var buffer:Float = 0.0 { //normalized,0 to 1
        didSet {
            setNeedsDisplay()
        }
    }
    
    var adPods:[AdPodPosition] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var thumbWidth:CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var maxProgressSize:Float = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        var progressStart:Float = 0
        if maxProgressSize < 1 && progress > maxProgressSize {
            progressStart = progress - maxProgressSize
            let trackPath = createPath(from:0, to:progressStart, in:rect, excluding:adPods)
            trackTintColor.set()
            trackPath.stroke()
        }
        let progressPath = createPath (from:progressStart, to:progress, in:rect, excluding:adPods)
        progressTintColor.set()
        progressPath.stroke()
        
        //check whether to show buffer and if yes, whether to offset it
        let showBuffer = buffer > progress
        let normalizedThumbHalfWidth = Float(thumbWidth / (rect.width * 2.0))
        let offset = buffer - progress <= normalizedThumbHalfWidth ? normalizedThumbHalfWidth : 0
        let bufferWithThumbOffset = min(buffer + offset, 1)
        let nextPos = showBuffer ? bufferWithThumbOffset : progress
        if showBuffer {
            let bufferPath = createPath (from:progress, to:bufferWithThumbOffset, in:rect, excluding:adPods)
            bufferTrackTintColor.set()
            bufferPath.stroke()
        }
        if progress < 1 {
            let trackPath = createPath (from:nextPos, to:1, in:rect, excluding:adPods)
            trackTintColor.set()
            trackPath.stroke()
        }
    }
}


extension ScrubberTrackView {
    func createPath (from:Float, to:Float, in rect:CGRect, excluding adPods:[AdPodPosition]) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.lineWidth = rect.height
        
        let assetDuration = rect.width
        let h = rect.height / 2.0
        
        var xStart = CGFloat(from) * assetDuration
        let xEnd = CGFloat(to) * assetDuration
        
        path.move(to: CGPoint(x:xStart, y:h))
        for adPod in adPods {
            let podMarkWidth = adPod.podMarkWidth
            
            let podStart = assetDuration * CGFloat(adPod.start)
            let podMarkEnd = podStart + podMarkWidth
            //if this path segment starts inside the add, move the start point to the position after the pod mark
            if podStart <= xStart && podMarkEnd > xStart {
                xStart = podMarkEnd
                path.move(to: CGPoint(x:xStart, y:h))
            }
            if podStart >= xStart && podStart <= xEnd {
                path.addLine (to: CGPoint(x:podStart, y:h))
                path.move(to: CGPoint(x:podMarkEnd, y:h))
            }
        }
        
        if path.currentPoint.x < xEnd {
            path.addLine (to: CGPoint (x:xEnd, y:h))
        }
        return path
    }
}
