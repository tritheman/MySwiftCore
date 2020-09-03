//
//  Scrubber.swift
//  TDHVideoCore
//
//  Created by Dang Huu Tri on 7/13/20.
//  Copyright © 2020 tridh.test.tiki. All rights reserved.
//

import Foundation
import UIKit

public protocol ScrubberProtocol {
    associatedtype ScrubberDelegate
    //Please assign this as weak please. We dont want thing get retained.
    var delegate: ScrubberDelegate? { get set }
    var scruberProgress: Float { get }
    var isActive: Bool { get }
    var bounds: CGRect { get }
    var bufferValue: Float { get set }
    func setScruberProgress(_ curProgress: Float)
}

public protocol ScrubberDelegate: class {
    func progressBarDidTap(progress: Float)
    func progressBarDidDrag(progress: Float)
    func progressBarDidFinishDrag(progress: Float)
}

