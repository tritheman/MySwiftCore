//
//  CustomProgressBar.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 1/21/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit

protocol CustomProgressBarProtocol {
    func setBarProgress(curProgress:Float)
}

@IBDesignable
class CustomProgressBar: UIProgressView, CustomProgressBarProtocol {
    
    private var trackView: ScrubberTrackView = ScrubberTrackView()
    fileprivate var isUserInteracting: Bool = false
    fileprivate var lastPoint: CGPoint?
    
    @objc var bufferValue:Float = 0.0 {// default 0.0. this value will be 0 - 1
        didSet { //clip value to [0, 1]
            if bufferValue < 0 {
                bufferValue = 0
            }
            if bufferValue > 1.0 {
                bufferValue = 1.0
            }
            updateTrackView()
        }
    }
    
    override var progress: Float {
        didSet {
            if progress <= 0 {
                bufferValue = 0.0
            }
        }
    }
    
    var adPods:[AdPodPosition] = [] {
        didSet {
            trackView.adPods = adPods
        }
    }
    
    @objc var bufferTintColor: UIColor? = nil {
        didSet {
            trackView.progressTintColor = bufferTintColor ?? defaultBufferTrackTintColor
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBufferProgressView()
        setupPanGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBufferProgressView()
        setupPanGesture()
    }
    
    func setupPanGesture() {
        trackView.isUserInteractionEnabled = false
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(self.detectPan(_:)))
        self.addGestureRecognizer(pangesture)
    }
    
    func setBarProgress(curProgress: Float) {
        if self.isUserInteracting == false {
            self.progress = curProgress
        }
    }
    
    @objc func detectPan(_ recognizer:UIPanGestureRecognizer) {
        let translation  = recognizer.translation(in: self.superview)
        switch recognizer.state {
        case .possible:
            fallthrough
        case .began:
            self.lastPoint = CGPoint(x: Int((self.progress*Float(self.frame.size.width))), y: 0)
            self.isUserInteracting = true
            self.lastPoint = translation
        case .changed:
            self.handleChanged(translation)
        case .ended:
            self.isUserInteracting = false
            self.didFinishChanged(translation)
        case .cancelled:
            fallthrough
        case .failed:
            fallthrough
        @unknown default:
            self.isUserInteracting = false
            if let previous = self.lastPoint {
                self.didFinishChanged(previous)
            }
        }

    }
    
    fileprivate func handleChanged(_ changes: CGPoint) {
        print("tridh2 test handleChanged \(changes)")
        let oldXposition = self.lastPoint?.x ?? 0
        let dragXPosition = oldXposition + changes.x
        let dragProgress = dragXPosition/self.frame.size.width
        print("tridh2 test drag changed \(dragProgress)")
        self.progress = Float(dragProgress)
    }
    
    fileprivate func didFinishChanged(_ changes: CGPoint) {
        
    }
    
    func setupBufferProgressView() {
        trackView.backgroundColor = UIColor.clear
        trackView.isUserInteractionEnabled = false
        
        if let trackTintColor = trackTintColor {
            trackView.trackTintColor = trackTintColor
        }
        if let bufferTintColor = bufferTintColor {
            trackView.progressTintColor = bufferTintColor
        }
        trackTintColor = UIColor.clear
        updateTrackView()
        insertSubview (trackView, at:0) //insert it behind other subviews
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackView.frame = bounds
        //Ensure that bufferProgressView stays in place (behind all the rest).
        if subviews.count > 0 && subviews.first != trackView {
            if  let bufferViewPos = subviews.firstIndex(of: trackView) {
                exchangeSubview(at: 0, withSubviewAt: bufferViewPos)
            }
        }
    }
    
    
    func updateTrackView() {
        trackView.progress = progress
        trackView.buffer = bufferValue
        trackView.adPods = adPods
        trackView.setNeedsDisplay()
    }
}
