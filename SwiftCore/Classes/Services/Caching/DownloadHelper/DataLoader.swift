
//
//  DataLoading.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/19/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

public typealias DidReceiveReponse = (Data, URLResponse) -> Void
public typealias DidCompleted = (Error?) -> Void

public enum DataTaskEvent {
    case resumed
    case receivedResponse(URLResponse)
    case receivedData(Data)
    case completed(Error?)
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
}

extension URLSessionTask: Cancellable {}

public protocol DataLoading {
    func loadData(request: URLRequest, didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) -> Cancellable
}

public protocol DataLoaderObserving {
    func dataLoader(_ loader: DataLoader, urlSession: URLSession, dataTask: URLSessionDataTask, didReceiveEvent event: DataTaskEvent)
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
    
    public func loadData(request: URLRequest, didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) -> Cancellable {
        return source.startDownload(request: request, session: session, didReceiveData: didReceiveData, completion: completion)
    }
    
}

extension DataLoader: DataLoaderSourceDelegate {
    func dataTask(_ dataTask: URLSessionDataTask, didReceiveEvent event: DataTaskEvent) {
        observer?.dataLoader(self, urlSession: session, dataTask: dataTask, didReceiveEvent: event)
    }
}


 
