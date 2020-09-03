//
//  PlayBackDelegte.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/19/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit

public enum PlaybackState {
    case notRunning
    case preparing
    case prepared
    case starting
    case started
    case paused
    case finished
    case seeking
    case resumed
    
    var message: String {
        switch self {
        case .notRunning:
            return "NotRunning"
        case .preparing:
            return "preparing"
        case .prepared:
            return "prepared"
        case .starting:
            return "starting"
        case .started:
            return "started"
        case .paused:
            return "paused"
        case .finished:
            return "finished"
        case .seeking:
            return "seeking"
        case .resumed:
            return "resumed"
        }
    }
}

public enum PlaybackStopReason {
  case reasonRequested /** Player was stopped before it could reach end of content due to a request via 'stop' */
  case reasonPreparingAnotherPlayer /** Another player is being prepared to replace this one */
  case reasonSystemEvent /** Player was forced to stop due to a system event (e.g. application backgrounding */
  case reasonNetworkChange /** Player was forced to stop due to a network change */
  case refreshActionRequest /** Player was stopped due to a refresh action */
}

public enum BufferingState {
    case unknown
    case ready
    case delayed
}

public enum VideoPlayerMode {
    case docked
    case popout
    case fullScreen
    case pip

  public var isFullScreenLandscape: Bool { return self.isFullScreen && UIDevice.current.orientation.isLandscape }
  public var isFullScreenPortrait: Bool { return self.isFullScreen  && UIDevice.current.orientation.isPortrait }
  public var isFullScreen: Bool { return self == .fullScreen }
}

