//
//  URL+Extension.swift
//
//  Created by TriDH on 11/28/18.
//

import Foundation
import UIKit

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
    
    func appending(_ parameters: [String: String]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        urlComponents.setQueryItems(with: parameters)
        return urlComponents.url!
    }

    
    public static func ==(lhs: URL, rhs: URL) -> Bool {
        return lhs.absoluteString == rhs.absoluteString
    }
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
