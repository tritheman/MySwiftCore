//
//  DownloadModel.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public struct DownloadModel {
    public var progress: Float = 0
    public var fileURL: String?
    public var countOfByteReceived: Double?
    public var countOfByteExpectedReceived: Double?
    fileprivate(set) public var destinationPath: String = ""
//    public var remainingTime: (hours: Int, minutes: Int, seconds: Int)?
//    public var speed: (speed: Float, unit: String)?
//    public var startTime: Date?
    
    public init(_ task: URLSessionTask) {
        self.countOfByteReceived = Double(task.countOfBytesReceived)
        self.countOfByteExpectedReceived = Double(task.countOfBytesExpectedToReceive)
        self.progress = Float(Double(task.countOfBytesReceived)/Double(task.countOfBytesExpectedToReceive))
        self.fileURL = task.currentRequest?.url?.absoluteString
    }
}
