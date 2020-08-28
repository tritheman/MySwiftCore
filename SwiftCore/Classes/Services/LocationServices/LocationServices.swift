//
//  LocationServices.swift
//  SwiftCore_Example
//
//  Created by Dang Huu Tri on 3/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CoreLocation

public let kNotificationLocationServicesZipcodeChanged = "kNotificationLocationServicesZipcodeChanged"
private let defaultLatitude = 33.930324
private let defaultLongitude = -118.386054

fileprivate enum LSUserDefaultsKeys: String {
  case settingsBundlePretendLocation = "pretendLocationLA"
  case settingsBundleZipcode = "pretendZipcodeLocation"
  case zipcode = "settingsZipcode"
  case location = "settingsLocation"
  case locationIDs = "locationIDs"
}

public class LocationServices : NSObject {
    
    
    static public let sharedInstance = LocationServices()
    fileprivate let locationManager = CLLocationManager()
    public var canSendLocation:Bool = false
    fileprivate var currentLocation:CLLocationCoordinate2D?
    fileprivate var zipcode: String?
//    public fileprivate (set) var locationStatusChange: MultiBindingsValue<Bool> = MultiBindingsValue<Bool>(value: false)
    
    public var usePretendLocation:Bool {
        return UserDefaults.standard.bool(forKey: LSUserDefaultsKeys.settingsBundlePretendLocation.rawValue)
    }

    fileprivate var pretendedZipCode: String? {
        get {
          return UserDefaults.standard.string(forKey: LSUserDefaultsKeys.zipcode.rawValue)
        }
        set {
          UserDefaults.standard.set(newValue, forKey: LSUserDefaultsKeys.zipcode.rawValue)
        }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    fileprivate var pretendedZipCodeLocation: CLLocationCoordinate2D? {
        get {
          if let location = UserDefaults.standard.object(forKey: LSUserDefaultsKeys.location.rawValue) as? Dictionary<String, Double> {
            if let lat = location["lat"], let long = location["long"] {
              return CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
          }
          return nil
        }
        set {
          if let latLong = newValue {
            let dict = ["lat": latLong.latitude, "long": latLong.longitude]
            UserDefaults.standard.set(dict, forKey: LSUserDefaultsKeys.location.rawValue)
          }
        }
    }
    
    public func startLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
              self.canSendLocation = true
              locationManager.distanceFilter = 1000
              locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
              locationManager.requestWhenInUseAuthorization()
              #if os(iOS)
                if #available(iOS 9.0, *) {
                  locationManager.allowsBackgroundLocationUpdates = false
                }
              #endif
              self.startLocationUpdate()
            }
    }
    
    fileprivate func startLocationUpdate() {
        locationManager.startUpdatingLocation()
        self.updateSettingsZipcodeLocation()
    }
    
    public func updateDistanceFilter(withDistance distance: Int) {
        locationManager.distanceFilter = Double(distance)
    }

    public func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
          switch CLLocationManager.authorizationStatus() {
          case .notDetermined, .denied, .restricted:
            return false
          case .authorizedAlways, .authorizedWhenInUse:
            return true
          }
        }
        return false
    }
    
    public func locationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private func updateSettingsZipcodeLocation() {
        if usePretendLocation {
          if let zCode = UserDefaults.standard.string(forKey: LSUserDefaultsKeys.settingsBundleZipcode.rawValue), zCode != pretendedZipCode {
            self.getForwardLocationFrom(zCode, completion: { (location) in
              if let loc = location {
                DispatchQueue.main.async {
                  self.pretendedZipCode = zCode
                  self.pretendedZipCodeLocation = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
                }
              }
            })
          }
        }
    }
    
    // Get Lat, Long from zipcode
    private func getForwardLocationFrom(_ zipcode: String!, completion:@escaping (CLLocationCoordinate2D?) -> Void) {
        CLGeocoder().geocodeAddressString(zipcode, completionHandler: { (placemarks, error) in
          if error != nil {
            completion(nil)
            return
          }
          
          if let marks = placemarks, marks.count > 0 {
            if let placemark = marks[0] as CLPlacemark?, let location = placemark.location {
              completion(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
              return
            }
          }
          completion(nil)
        })
    }
    
    public func currentLocationLatitude() -> CLLocationDegrees {
        if usePretendLocation {
          if let zCode = UserDefaults.standard.string(forKey: LSUserDefaultsKeys.settingsBundleZipcode.rawValue) {
            if zCode == pretendedZipCode, self.pretendedZipCodeLocation != nil {
              return self.pretendedZipCodeLocation!.latitude
            }
            else {
              return defaultLatitude
            }
          }
          
          return defaultLatitude
        }
        
        guard let location = currentLocation else {
          return 0.0
        }
        
        return location.latitude
    }
    
    public func currentLocationLongitude() -> CLLocationDegrees {
        if usePretendLocation {
          if let zCode = UserDefaults.standard.string(forKey: LSUserDefaultsKeys.settingsBundleZipcode.rawValue) {
            if zCode == pretendedZipCode, self.pretendedZipCodeLocation != nil {
              return self.pretendedZipCodeLocation!.longitude
            }
            else {
              // Get longitude from zipCode
              return defaultLongitude
            }
          }
          
          return defaultLongitude
        }
        
        guard let location = currentLocation else {
          return 0.0
        }
        
        return location.longitude
    }
    
    public func curentLatitudeAndLongitude() -> (latitude: String, longitude: String)? {
        if usePretendLocation {
          if let zCode = UserDefaults.standard.string(forKey: LSUserDefaultsKeys.settingsBundleZipcode.rawValue) {
            if zCode == pretendedZipCode, self.pretendedZipCodeLocation != nil {
              return ("\(self.pretendedZipCodeLocation!.latitude)", "\(self.pretendedZipCodeLocation!.longitude)")
            }
            else {
              return ("\(defaultLatitude)", "\(defaultLongitude)")
            }
          }
          
          return ("\(defaultLatitude)", "\(defaultLongitude)")
        }
        
        guard let location = currentLocation else {
          return nil
        }
        
        return("\(location.latitude)", "\(location.longitude)")
    }
    
    public func currentLocationZipCode() -> String {
        if UserDefaults.standard.bool(forKey: "pretendLocationLA") {
          return "90245"
        }
        
        guard let zipcode = zipcode else {
          return "0"
        }
        return zipcode
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus)
    {
        self.canSendLocation = false
        if status == .authorizedAlways || status == .authorizedWhenInUse {
          
          self.startLocationUpdate()
          
          self.canSendLocation = true
        } else if status == .notDetermined || status == .denied {
          locationManager.requestWhenInUseAuthorization()
        }
//      self.locationStatusChange.value = true
    }
    
    func safeLog(_ msg: String) -> String {
        return self.secure(msg)
    }
    
    private func secure(_ substring: String) -> String {
        return substring.encodeWithXorByte(key:86)
    }
    
    // AppLevel Location Configuration, Location ID's contains DMAIDs, CCDMAIDs, FOXDMAIDs
    // MARK: LocationID's Configuration
    
    private var privateLocationDictionary: Dictionary<String, String>?
    public var locationIdDictionary: Dictionary<String, String>? {
        get {
          // If available get it from the private property
          if let locationDict = privateLocationDictionary,
            locationDict.count > 0 {
            return locationDict
          }
          else {
            // Read from the user default
            if let locationIDs = UserDefaults.standard.object(forKey: LSUserDefaultsKeys.locationIDs.rawValue) as? Dictionary<String, String>,
              locationIDs.count > 0 {
              privateLocationDictionary = locationIDs
              return locationIDs
            }
            return nil
          }
        }
        set {
          UserDefaults.standard.set(newValue, forKey: LSUserDefaultsKeys.locationIDs.rawValue)
          privateLocationDictionary = newValue
        }
    }
}

extension LocationServices: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
          return
        }
        self.currentLocation = location.coordinate
        // Update ZIP code when location changes
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error)-> Void in
          guard let placemarks = placemarks, error == nil else {
            print("Reverse geocoder failed with error: \(error!.localizedDescription)")
            return
          }
          guard placemarks.count > 0 else {
            print("No placemarks found.")
            return
          }
          let placemark = placemarks[0]
          guard let zipcode = placemark.postalCode else {
            return
          }
          if(zipcode == self.zipcode) {
            return
          }
          self.zipcode = zipcode
          NotificationCenter.default.post(name: Notification.Name(rawValue: kNotificationLocationServicesZipcodeChanged), object: self.zipcode)
        })
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      // TODO this should be implemented
    }
    
}
