//
//  StreamSourceProtocol.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/20/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//
import UIKit
import Foundation
import AVFoundation

public protocol AVPlayerContentProtocol {
    var player: AVPlayer { get set }
    var isSeeking: Bool { get set }
    var isMuted: Bool { get set }
    var isBuffering: Bool { get }
    var isFastForwardEnabled: Bool { get }
    var isRewindEnabled: Bool { get }
    var playbackRate: Float { get set }
    var videoStartTime: TimeInterval? { get}
    var nominalFrameRate: Float? { get }
    var maxBitRate: UInt { get set } // in BPS (bits per second) so 1MBPS is 1000000
    var initialPlaybackTime: TimeInterval? { get set }
    var bufferedTime : TimeInterval? { get set }
    var isStreamResumable: Bool { get }
    var currentTime: TimeInterval? { get }
    var currentDate: Date? { get }
    var duration: TimeInterval? { get }

    func seek(toTime time: TimeInterval) -> Bool
}


public protocol StreamSourceProtocol: AVPlayerContentProtocol, StreamSourceClosedCaptionProtocol, PIPProtocol, StreamSourceServiceProtocol {
    var delegate: StreamSourceDelegate? { get set }
    var playbackView : UIView? { get }
    var thumbnailView: UIView? { get }
    
    func preparePlayback()
    func startPlayback()
    func pausePlayback()
    func stopPlayback()
    func videoModeWillChange(_ mode: VideoPlayerMode)
}


public protocol StreamSourceServiceProtocol {
    func startServiceWithConfiguration(configuration: [AnyHashable: Any])
    func stopService()
    func isServiceStarted() -> Bool
    func updateUserAccessToken(_ userAccessToken: String)
    func updateActivationToken(_ newActivationToken: String)
}


public protocol StreamSourceClosedCaptionProtocol {
    func availableClosedCaptionTracks(closedCaptions:Bool, subtitles:Bool)  -> [StreamSourceTrack]?
    func availableAudioTracks() -> [StreamSourceTrack]?
    var selectedAudioTrack: StreamSourceTrack? { get set }
    var selectedClosedCaptionTrack: StreamSourceTrack? { get set }
}

public protocol PIPProtocol: class {
    var isPictureInPictureActive: Bool { get }
    var isPictureInPictureEnabled: Bool { get set }
    var isPictureInPicturePossible: Bool { get }
    func stopPictureInPictureMode()
}
