//
//  SliderWithBuffer.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 1/21/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import UIKit

class SliderWithBuffer: UISlider, ScrubberProtocol {
    
    var scruberProgress: Float {
        get {
            return value
        }
    }
    weak var delegate: ScrubberDelegate?
    private(set) var isActive: Bool = false
    private var trackView: ScrubberTrackView = ScrubberTrackView()
    
    var bufferValue:Float = 0.0 {
        didSet {
            if bufferValue < minimumValue {
                bufferValue = minimumValue
            }
            if bufferValue > maximumValue {
                bufferValue = maximumValue
            }
            updateTrackView()
        }
    }

    var bufferTrackTintColor:UIColor? = nil {
        didSet {
            if let bufferColor = bufferTrackTintColor {
                trackView.bufferTrackTintColor = bufferColor
            }
        }
    }
    
    override var value: Float {
        didSet {
            if value <= 0 {
                bufferValue = 0.0
            }
            updateTrackView()
        }
    }
    
    override var minimumValue: Float {
        didSet {
            if leftScrubbingLimit < minimumValue {
                leftScrubbingLimit = minimumValue
            }
        }
    }
    override var maximumValue: Float {
        didSet {
            if rightScrubbingLimit > maximumValue {
                rightScrubbingLimit = maximumValue
            }
        }
    }
    
    var adPods:[AdPodPosition] = [] {
        didSet {
            trackView.adPods = adPods
        }
    }
    
    var leftScrubbingLimit: Float = 0 {
        didSet {
            if leftScrubbingLimit < minimumValue {
                leftScrubbingLimit = minimumValue
            }
            if value < leftScrubbingLimit {
                setValue(leftScrubbingLimit, animated:true)
                //sendActions(for: .valueChanged)
            }
            updateTrackView()
        }
    }
    var rightScrubbingLimit: Float = 1 {
        didSet {
            if rightScrubbingLimit > maximumValue {
                rightScrubbingLimit = maximumValue
            }
            if value > rightScrubbingLimit {
                setValue(rightScrubbingLimit, animated:true)
                //sendActions(for: .valueChanged)
            }
            updateTrackView()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        configureThumbImages()
        setupTrackView()
        initTapGesture()
    }
    
    func setScruberProgress(_ curProgress: Float) {
        if !isActive {
            self.value = curProgress
        }
    }
    
    func setupTrackView() {
        if let progressTintColor = minimumTrackTintColor {
            trackView.progressTintColor = progressTintColor
        }
        if let trackTintColor = maximumTrackTintColor {
            trackView.trackTintColor = trackTintColor
        }
        minimumTrackTintColor = UIColor.clear
        maximumTrackTintColor = UIColor.clear
        trackView.backgroundColor = UIColor.clear
        trackView.isUserInteractionEnabled = false
        
        insertSubview(trackView, at: 0)
        updateTrackView()
    }
    
    func configureThumbImages() {
        let bundle = Bundle(for: type(of: self))
        let inactiveImage = UIImage(named:"scrubber-inactive", in: bundle, compatibleWith:nil)
        let pressedImage = UIImage(named:"scrubber-press", in: bundle, compatibleWith:nil)
        setThumbImage(inactiveImage, for: .normal)
        setThumbImage(inactiveImage, for: .disabled)
        setThumbImage(pressedImage, for: .highlighted)
    }
    
    override func setValue(_ value: Float, animated: Bool) {
        super.setValue(value, animated: animated)
        updateTrackView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let trackRect = self.trackRect(forBounds: bounds)
        trackView.frame = trackRect
        trackView.thumbWidth = self.thumbRect(forBounds: bounds, trackRect:trackRect, value:value).width
    }
    
    
    func updateTrackView() {
        let range = maximumValue - minimumValue
        if leftScrubbingLimit > minimumValue || rightScrubbingLimit < maximumValue {
            //when limits are set, the progress actually represents the live buffer rather than current position
            trackView.progress = (rightScrubbingLimit - minimumValue)/range
            trackView.maxProgressSize = (rightScrubbingLimit - leftScrubbingLimit)/range
        } else {
            trackView.maxProgressSize = 1
            trackView.progress = (value - minimumValue)/range
        }
        trackView.buffer = (bufferValue - minimumValue)/range
        trackView.adPods = adPods
        trackView.setNeedsDisplay()
    }
    
    //MARK: - Touch tracking
    var beganTrackingLocation = CGPoint.zero
    var realPositionValue : Float = 0
    
    func shouldEnableTracking(for touch: UITouch) -> Bool {
        if leftScrubbingLimit > minimumValue || rightScrubbingLimit < maximumValue {
            //if at least one of the limits is set
            return self.value >= leftScrubbingLimit && self.value <= rightScrubbingLimit
        }
        
        return true
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if !shouldEnableTracking(for:touch) {
            return false
        }
        let begin = super.beginTracking(touch, with: event)
        if begin {
            let thumb = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
            
            beganTrackingLocation = CGPoint(x:thumb.origin.x + thumb.width / 2.0,
                                            y:thumb.origin.y + thumb.height / 2.0)
            realPositionValue = value
        } else {
            sendActions(for: .touchUpOutside)
        }
        
        return begin
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let previousLocation = touch.previousLocation(in: self)
        let currentLocation = touch.location(in: self)
        let trackingOffset = currentLocation.x - previousLocation.x
        
        let track = trackRect( forBounds:bounds)
        realPositionValue = realPositionValue + (maximumValue - minimumValue) * Float(trackingOffset / track.width)
        value = clipValueToScrubbingLimits(realPositionValue)
        delegate?.progressBarDidDrag(progress: value)
        let keepTracking = fabsf(realPositionValue - value) <= fabsf(0.01)
        
        if isContinuous && keepTracking {
            sendActions(for: .valueChanged)
        }
        
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.progressBarDidFinishDrag(progress: value)
        super.endTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        delegate?.progressBarDidFinishDrag(progress: value)
        super.cancelTracking(with: event)
    }
    
    func clipValueToScrubbingLimits(_ value:Float) -> Float {
        if value > rightScrubbingLimit {
            return rightScrubbingLimit
        } else if value < leftScrubbingLimit {
            return leftScrubbingLimit
        }
        return value
    }
    
    func resetLimits() {
        if leftScrubbingLimit > minimumValue || rightScrubbingLimit < maximumValue {
            leftScrubbingLimit = minimumValue
            rightScrubbingLimit = maximumValue
            updateTrackView()
        }
    }
    
    // MARK: - tap support
    private func initTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sliderTapped)))
        addTarget(self, action: #selector(activated), for: .touchDown)
        addTarget(self, action: #selector(deactivated), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func activated() {
        isActive = true
    }
    
    @objc private func deactivated() {
        isActive = false
    }
    
    @objc private func sliderTapped(gestureRecognizer: UITapGestureRecognizer) {
        guard !isActive else { return }
        let track = trackRect(forBounds:bounds)
        let trackWidth = track.width
        let tapLocationX = gestureRecognizer.location(in: self).x
        let offset = min(trackWidth, max (0, tapLocationX - track.origin.x))
        
        let ratio = offset / trackWidth
        
        let tappedValue = clipValueToScrubbingLimits(minimumValue + (maximumValue - minimumValue) * Float(ratio))
        // Simulate dragging the slider to the touched point.
        sendActions(for: .touchDown)
        self.setValue(tappedValue, animated: true)
        sendActions(for: .valueChanged)
        sendActions(for: .touchUpInside)
        delegate?.progressBarDidTap(progress: tappedValue)
    }
    
    
}
