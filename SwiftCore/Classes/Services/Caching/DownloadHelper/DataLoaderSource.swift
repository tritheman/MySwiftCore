//
//  DataLoaderSource.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

protocol DataLoaderSourceDelegate: class {
    func dataTask(_ dataTask: URLSessionDataTask, didReceiveEvent event: DataTaskEvent)
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
        let task = session.dataTask(with: request)
        let handler = Handler(didReceiveData: didReceiveData, completion: completion)
        session.delegateQueue.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.handlers[task] = handler
        }
        task.resume()
        send(task, .resumed)
        return task
    }
    
    private func send(_ dataTask: URLSessionDataTask, _ event: DataTaskEvent) {
        print("--------------------------------")
        switch event {
        case .resumed:
            print("tridh2 DataTaskEvent - resumed")
        case .receivedResponse(let reponse):
            print("tridh2 DataTaskEvent - receivedResponse: \(String(describing: reponse.url?.absoluteURL))")
        case .receivedData(let data):
            let tottalbyte = dataTask.countOfBytesExpectedToReceive
            let receivedByte = dataTask.countOfBytesReceived
            print("tridh2 DataTaskEvent - receivedData: \(receivedByte) - expected: \(tottalbyte)")
        case .completed(let error):
            print("tridh2 DataTaskEvent - completed: \(String(describing: error))")
        }
        print("tridh2 dataTask - \(String(describing: dataTask.currentRequest))")
        print("--------------------------------")
        delegate?.dataTask(dataTask, didReceiveEvent: event)
    }
}

extension DataLoaderSource: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        send(dataTask, .receivedResponse(response))
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
        send(dataTask, .receivedData(data))
        
        guard let handler = handlers[dataTask], let response = dataTask.response else {
            return
        }
        
        handler.didReceiveData(data, response)
    }
}

extension DataLoaderSource: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let dataTask = task as? URLSessionDataTask {
            send(dataTask, .completed(error))
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

//extension DataLoaderSource: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        print("tridh2 - URLSessionDownloadDelegate - \(location.absoluteString)")
//        if let dataTask = downloadTask as? URLSessionTask {
//            send(dataTask, .completed(nil))
//        }
//
//        guard let handler = handlers[dataTask] else {
//            return
//        }
//        handlers[task] = nil
//        handler.completion(nil)
//
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print("tridh2 - URLSessionDownloadDelegate - totalBytesWritten: \(totalBytesWritten) - totalBytesExpectedToWrite: \(totalBytesExpectedToWrite)")
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//        print("tridh2 - URLSessionDownloadTask - didResumeAtOffset: \(fileOffset) - expectedTotalBytes: \(expectedTotalBytes)")
//    }
//}
