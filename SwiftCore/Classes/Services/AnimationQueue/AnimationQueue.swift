//
//  AnimationQueue.swift
//  BaseApplication
//
//  Created by Dang Huu Tri on 1/19/20.
//  Copyright © 2020 Dang Huu Tri. All rights reserved.
//

import Foundation
import UIKit

public class AnimationQueue {
    private let queue: DispatchQueue
    public init(label: String) {
      self.queue = DispatchQueue(label: label)
    }
    
    public func submitAnimations(withDuration duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
      let semaphore = DispatchSemaphore(value: 0)
      queue.async {
        let _ = semaphore.wait(timeout: .now() + 60.0)
      }
      DispatchQueue.main.async {
        UIView.animate(withDuration: duration, animations: animations, completion: { (finished) in
          semaphore.signal()
          completion?(finished)
        })
      }
    }
    
    public func submitBatchUpdates(to collectionView: UICollectionView, updates: @escaping () -> Void, completion: ((Bool) -> Void)?) {
      
      let semaphore = DispatchSemaphore(value: 0)
      queue.async {
        let _ = semaphore.wait(timeout: .now() + 60.0)
      }
      
      DispatchQueue.main.async {
        UIView.beginAnimations(nil, context:nil)
        CATransaction.begin()
        collectionView.performBatchUpdates(updates, completion: { (finished) in
          semaphore.signal()
          completion?(finished)
        })
        CATransaction.commit()
        UIView.commitAnimations()
      }
    }
}
