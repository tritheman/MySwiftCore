//
//  StreamSourceProtocol+Default.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/20/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

// these default attribute only for those attribute we can get conlusion from the AVPlayer only -> so that we dont need to rewrite these in varient StreamingSource object.
public extension StreamSourceProtocol {
    var isBuffering: Bool {
      get {
        return false
      }
    }
    
    var thumbnailView: UIView? {
      get {
        return nil
      }
    }
    
    var isStreamResumable: Bool {
      get {
        return true
      }
    }
    
    var maxBitRate: UInt {
      get {
        if let currentItem = player.currentItem {
          return UInt(currentItem.preferredPeakBitRate)
        }
        return 0
      }
      set {
        if let currentItem = player.currentItem {
          currentItem.preferredPeakBitRate = Double(newValue)
        }
      }
    }
    
    var isMuted: Bool {
      get {
        return player.isMuted
      }
      set(muted) {
        player.isMuted = muted
      }
    }
    
    var currentTime: TimeInterval? {
      return CMTimeGetSeconds(player.currentTime())
    }
    
    var currentDate: Date? {
      if let item = player.currentItem {
        return item.currentDate()
      }
      return nil
    }
    
    var duration: TimeInterval? {
      if let duration = player.currentItem?.duration {
        return CMTimeGetSeconds(duration)
      }
      return nil
    }
    
    var isFastForwardEnabled: Bool {
      if let duration = duration {
        return duration > 0
      }
      return false
    }
    
    var isRewindEnabled: Bool {
      get {
        return isFastForwardEnabled
      }
    }
    
    var playbackRate: Float {
      get {
        return player.rate
      }
      set {
        player.rate = newValue
      }
    }
    
    func preparePlayback() {
        player.play()
        player.pause()
    }
    
    func startPlayback() {
        player.play()
    }
    
    func pausePlayback() {
        player.pause()
    }
    
    func videoModeWillChange(_ mode: VideoPlayerMode) {
      // empty default implementation
    }
}

public extension PIPProtocol {
    var isPictureInPictureActive: Bool { return false }
    var isPictureInPictureEnabled: Bool { return true }
    var isPictureInPicturePossible: Bool { return false }
    func stopPictureInPictureMode() { }
}
