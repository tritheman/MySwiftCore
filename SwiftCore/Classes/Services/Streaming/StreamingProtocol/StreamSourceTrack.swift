//
//  StreamSourceTrack.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/20/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation

public enum TrackType {
  case unknown
  case audio
  case closedCaption
  case subtitle
}

public struct StreamSourceTrack: CustomStringConvertible {

  public let trackType: TrackType
  public let displayName: String
  public var track: AnyObject?
  
  public init(track:AnyObject?, displayName:String, trackType: TrackType = .unknown) {
    self.track = track
    self.trackType = trackType
    self.displayName = displayName
  }
  
  public var description:String {
    return displayName
  }
}
