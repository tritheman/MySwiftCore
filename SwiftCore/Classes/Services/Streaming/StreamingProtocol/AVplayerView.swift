//
//  AVplayerView.swift
//  VideoPlayerCore
//
//  Created by Dang Huu Tri on 1/19/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AVPlayerView : UIView {
  
  override class var layerClass: Swift.AnyClass
    {
    get
    {
      return AVPlayerLayer.self
    }
  }
  
  public var player: AVPlayer? {
    
    get {
      
      return (self.layer as? AVPlayerLayer)?.player
    }
    set {
      
      (self.layer as? AVPlayerLayer)?.player = newValue
    }
  }
}
