//
//  BaseOperation.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/13/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

open class BaseOperation: Operation {
    private var _executing = false
    private var _finished = false
    
    override private(set) open var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override private(set) open var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        if isCancelled {
            isFinished = true
            return
        }
        
        isExecuting = true
        
        autoreleasepool {
            run()
        }
    }
    
    open func run() {
        preconditionFailure("AsyncOperation.run() abstract method must be overridden.")
    }
    
    open func finishedExecutingOperation() {
        isExecuting = false
        isFinished = true
    }
}

public class AsyncBlockOperation : BaseOperation {
    let action : (_ operation:AsyncBlockOperation)->Void
    
    public init(_ action: @escaping (_ operation:AsyncBlockOperation)->Void ) {
        self.action = action
    }
    
    override public func run() {
        action(self)
    }
}
