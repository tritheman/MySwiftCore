
//
//  DataLoading.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/19/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public typealias DidReceiveReponse = (Data?, URLResponse?, DownloadModel) -> Void
public typealias DidCompleted = (Error?) -> Void

public enum DataTaskEvent {
    case resumed(DownloadModel)
    case receivedResponse(DownloadModel)
    case becameDownload(DownloadModel)
    case receivedData(DownloadModel)
    case completed(Error?)
    
    var downloadObject: DownloadModel? {
        switch self {
        case .resumed(let downloadModel):
            return downloadModel
        case .receivedResponse(let downloadModel):
            return downloadModel
        case .becameDownload(let downloadModel):
            return downloadModel
        case .receivedData(let downloadModel):
            return downloadModel
        default:
            return nil
        }
    }
}

public enum DataLoaderError: Error {
    case statusCodeUnacceptable(Int)

    public var message: String {
        switch self {
        case let .statusCodeUnacceptable(code):
            return "Response status code was unacceptable: \(code.description)"
        }
    }
}

public protocol Cancellable: AnyObject {
    func cancel()
    func suspend()
    func resume()
}

extension URLSessionTask: Cancellable {}

public protocol DataLoading {
    func loadData(request: URLRequest, didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) -> Cancellable
}

public protocol DataLoaderObserving {
    func dataLoader(_ loader: DataLoader, urlSession: URLSession, dataTask: URLSessionTask, didReceiveEvent event: DataTaskEvent)
}

public final class DataLoader: DataLoading {

    public let session: URLSession
    private let source: DataLoaderSource = DataLoaderSource()
    public var observer: DataLoaderObserving?
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public init(configuration: URLSessionConfiguration = DataLoader.defaultConfiguration, validate: @escaping (URLResponse) -> DataLoaderError? = DataLoader.validate) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        self.session = URLSession(configuration: configuration, delegate: source, delegateQueue: queue)
        self.source.validate = validate
        self.source.delegate = self
    }
    
    @discardableResult
    public func loadData(request: URLRequest, didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) -> Cancellable {
        return source.startDownload(request: request, session: session, didReceiveData: didReceiveData, completion: completion)
    }
    
    fileprivate func downloadTasks() -> [URLSessionDownloadTask] {
        var tasks: [URLSessionDownloadTask] = []
        let semaphore : DispatchSemaphore = DispatchSemaphore(value: 0)
        session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) -> Void in
            tasks = downloadTasks
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return tasks
    }
    
    func populateOtherDownloadTasks() {
        let downloadTasks = self.downloadTasks()
        
        for downloadTask in downloadTasks {
            if downloadTask.state == .running {
                downloadTask.resume()
            } else if(downloadTask.state == .suspended) {
                downloadTask.resume()
            } else {
                
            }
        }
    }
}

extension DataLoader: DataLoaderSourceDelegate {
    func dataTask(_ dataTask: URLSessionTask, didReceiveEvent event: DataTaskEvent) {
        observer?.dataLoader(self, urlSession: session, dataTask: dataTask, didReceiveEvent: event)
    }
}


 
