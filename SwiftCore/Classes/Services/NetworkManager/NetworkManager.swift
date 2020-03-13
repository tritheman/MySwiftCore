//
//  NetworkManager.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

public let kNotificationNetworkChanged          = "NotificationNetworkChanged"
public let notificationUserInfoFromBackground   = "cameFromBackground"
public let kNotificationNetworkChangedDelay     = 0.0

public class NetworkManager {
    public static let shared = NetworkManager()
    public private(set) var currentNetworkType = NetworkType.unknown
    fileprivate var currentNetworkBSSId: String?
    fileprivate var isNotificationSent: Bool!
    fileprivate var reachability = try! Reachability()
    fileprivate var connectivityEndPoints = ["https://www.google.com/","https://www.apple.com/"]
    
    var isConnected: Bool {
        return currentNetworkType != NetworkType.none
    }
    
    var isConnectedViaWWan: Bool {
        return currentNetworkType == NetworkType.cellular
    }
    
    var isConnectedViaEthernetOrWifi: Bool {
        return (currentNetworkType == NetworkType.ethernet || currentNetworkType == NetworkType.wifi)
    }
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(NetworkManager.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
          try reachability.startNotifier()
        } catch {
          print("Unable to start Reachability notifier")
        }
    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    @objc func reachabilityChanged(_ notification: Notification) {
        guard let isNotificationSent = isNotificationSent else { return }
        //Check for isNotification else it will crash..
        if !isNotificationSent {
            self.updateConnectionType(fromBackground: false)
        }
    }
  
    public func setConnectivityEndPoints(_ endPoints: [String]) {
        self.connectivityEndPoints = endPoints
    }
  
    func updateConnectionType(fromBackground : Bool){
        isNotificationSent = true
        let delay = kNotificationNetworkChangedDelay * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + delay / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            self.isNotificationSent = false
            let status = self.reachability.connection
            let oldNetworkType = self.currentNetworkType
            self.currentNetworkType = self.networkTypeForReachabilityStatus(status)
            switch self.currentNetworkType {
            case .none, .unknown:
                self.updateStatus(oldNetworkType: oldNetworkType, fromBackground: fromBackground)
                break
            case .cellular, .ethernet, .wifi:
                self.updateStatus(oldNetworkType: .unknown, fromBackground: fromBackground)
            }
        })
    }
  
    func updateStatus(oldNetworkType: NetworkType, fromBackground : Bool) {
        let networkTypeChanged = self.currentNetworkType != oldNetworkType
    
        if networkTypeChanged || self.networkChanged() {
            let userInfo = fromBackground ? [notificationUserInfoFromBackground: true] : nil
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationNetworkChanged), object: nil, userInfo: userInfo)
        }
    }
    
    open func networkChanged() -> Bool {
        if Platform.isSimulator == true{
            return false
        } else {
            //Compare between old and new wifi name.
            let oldNetworkInterfaceId = self.currentNetworkBSSId
            self.currentNetworkBSSId = self.getCurrentInterfaceId()?.ssid
            let wifiChanged = self.currentNetworkBSSId != oldNetworkInterfaceId
            return wifiChanged || (self.currentNetworkBSSId == "")
        }
    }
  
    open func notifyNetworkChange(cameFromBackground: Bool) {
        updateConnectionType(fromBackground: true)
    }
  
    fileprivate func networkTypeForReachabilityStatus(_ status: Reachability.Connection) -> NetworkType {
        var type: NetworkType = .none
        switch status {
        case .none:
            type = .none
        case .cellular:
            type = .cellular
        case .wifi:
            type = .wifi
        default:
            type = .unknown
        }
        return type
    }
  
    class func nameForNetworkType(_ type: NetworkType) -> String {
        var name: String = ""
        switch type {
        case .none:
            name = "None"
        case .wifi:
            name = "Wifi"
        case .cellular:
            name = "Cellular"
        case .ethernet:
            name = "Ethernet"
        default:
            name = "Unknown"
        }
        return name
    }

    class func nameForQPDiscoveryNetworkType(_ type: NetworkType) -> String {
        var name: String = ""
        switch type {
        case .none:
            name = "None"
        case .wifi:
            name = "WIFI"
        case .cellular:
            name = "CELLULAR"
        case .ethernet:
            name = "Ethernet"
        default:
            name = "Unknown"
        }
        return name
    }
  
    func getCurrentInterfaceId() -> (ssid: String?, bssid: String?)? {
        var currentSSID: String? = ""
        var currentBSSID: String? = ""
        if let interfaces = CNCopySupportedInterfaces() {
            if let interfacesArray = interfaces as? [String], interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as String
                let data = CNCopyCurrentNetworkInfo(interfaceName as CFString)
                if let unsafeInterfaceData = data {
                    let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
                    currentSSID = interfaceData["SSID"] as? String
                    currentBSSID = interfaceData["BSSID"] as? String
                }
            }
        }
        return (currentSSID, currentBSSID)
    }
}
