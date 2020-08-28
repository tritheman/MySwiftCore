//
//  DataLoaderSource.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

protocol DataLoaderSourceDelegate: class {
    func dataTask(_ dataTask: URLSessionTask, didReceiveEvent event: DataTaskEvent)
}

class Handler {
    let didReceiveData: DidReceiveReponse
    let completion: DidCompleted
    
    init(didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) {
        self.didReceiveData = didReceiveData
        self.completion = completion
    }
}

class DataLoaderSource: NSObject {
    
    var validate: (URLResponse) -> DataLoaderError? = DataLoader.validate
    fileprivate var handlers = [URLSessionTask: Handler]()
    weak var delegate: DataLoaderSourceDelegate?
    
    func startDownload(request: URLRequest, session: URLSession, didReceiveData: @escaping DidReceiveReponse, completion: @escaping DidCompleted) -> Cancellable {
        let task = session.downloadTask(with: request)
        let handler = Handler(didReceiveData: didReceiveData, completion: completion)
        session.delegateQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.handlers[task] = handler
        }
        task.resume()
        sendToDelegate(task, .resumed(DownloadModel(task)))
        return task
    }
    
    private func sendToDelegate(_ dataTask: URLSessionTask, _ event: DataTaskEvent) {
        delegate?.dataTask(dataTask, didReceiveEvent: event)
    }
}

extension DataLoaderSource: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        sendToDelegate(dataTask, .receivedResponse(DownloadModel(dataTask)))
        guard let curHandler = handlers[dataTask] else {
            completionHandler(.cancel)
            return
        }
        if let error = validate(response) {
            curHandler.completion(error)
            completionHandler(.cancel)
            return
        }
        let expectedReceivedSize = dataTask.countOfBytesExpectedToReceive
        if expectedReceivedSize > (2 * 1024 * 1024) {
            completionHandler(.becomeDownload)
        } else {
            completionHandler(.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        sendToDelegate(dataTask, .receivedData(DownloadModel(dataTask)))
        
        guard let handler = handlers[dataTask], let response = dataTask.response else {
            return
        }
        
        handler.didReceiveData(data, response, DownloadModel(dataTask))
    }
}

extension DataLoaderSource: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let dataTask = task as? URLSessionDataTask {
            sendToDelegate(dataTask, .completed(error))
        }
        
        guard let handler = handlers[task] else {
            return
        }
        handlers[task] = nil
        handler.completion(error)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

extension DataLoaderSource: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        sendToDelegate(downloadTask, .completed(nil))
        guard let handler = handlers[downloadTask] else {
            return
        }
        handlers[downloadTask] = nil
        handler.completion(nil)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        sendToDelegate(downloadTask, .receivedData(DownloadModel(downloadTask)))
        guard let handler = handlers[downloadTask] else {
            return
        }
        handler.didReceiveData(nil, nil, DownloadModel(downloadTask))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        sendToDelegate(downloadTask, .resumed(DownloadModel(downloadTask)))
        guard let handler = handlers[downloadTask] else {
            return
        }
        handler.didReceiveData(nil, nil, DownloadModel(downloadTask))
    }
}
