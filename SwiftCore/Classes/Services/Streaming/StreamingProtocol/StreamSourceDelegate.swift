//
//  BufferingState.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/19/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit

public protocol PlayBackDelegate: class {
    func playbackStateChanged(_ state: PlaybackState)
    func playbackStopped(_ reason: PlaybackStopReason)
    func playbackFailed(_ error: StreamError)
    func playbackRateChanged(_ rate: CGFloat)
    func playbackVolumeChanged(_ newVolume: Float)
    func playbackmuteStateChanged(_ state: Bool)
}

public protocol PlayerDelegate: class {
    func playerCurrentTimeChanged(_ duration: TimeInterval?)
    func playerBufferTimeChanged(_ bufferTime: Double)
    func playerBufferingStateChanged(state: BufferingState)
    func playerWillStartFromBeginning()
    func playerPlaybackDidEnd()
    func playerPlaybackWillLoop()
    func playerPlaybackDidLoop()
}

//for future if each time we init a streamsource using another service from third party like NDS...
public protocol StreamServicesDelegate {
    func serviceDidStart()
    func serviceStartFailed(_ error: StreamError)
}

public protocol StreamSourceDelegate: PlayerDelegate, PlayBackDelegate, StreamServicesDelegate { }


