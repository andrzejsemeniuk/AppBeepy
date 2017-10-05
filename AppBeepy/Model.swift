//
//  Model.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/5/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreLocation
import ASToolkit

class Model : NSObject {
    
    struct Value {
        var value               : String? {
            get {
                return self.values.current
            }
            set {
                self.values.previous    = self.values.current
                self.values.current     = newValue
                self.changed            = self.values.previous != self.values.current
            }
        }
        var old                 : String? {
            get {
                return self.values.previous
            }
        }
        var changed             : Bool = false
        
        init(value:String = "?") {
            self.value = value
        }
        
        private var values      : (current:String?,previous:String?) = (nil,nil)
        
        mutating func set                (fromString v:String)  -> Bool   {
            self.value = v
            return self.changed
        }
        mutating func set                (fromDouble v:Double)  -> Bool   {
            self.value = "\(v)"
            return self.changed
        }
        mutating func set                (fromFloat v:Double)   -> Bool   {
            self.value = "\(v)"
            return self.changed
        }

    }
    
    var valueLocationCoordinateLatitude                 = BindingValue<Value>(Value())
    var valueLocationCoordinateLongitude                = BindingValue<Value>(Value())
    var valueLocationAltitude                           = BindingValue<Value>(Value())

    var valueHeadingMagnetic                            = BindingValue<Value>(Value())

    var locationManager : CLLocationManager!
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
    }
    
    fileprivate func update(_ value:BindingValue<Value>!, withString:String) {
        if value.value?.set(fromString: withString) ?? false {
            value.fire()
        }
    }

    fileprivate func update(_ value:BindingValue<Value>!, withDouble:Double) {
        if value.value?.set(fromDouble: withDouble) ?? false {
            value.fire()
        }
    }
}

extension Model : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let heading = manager.heading {
            self.update(valueHeadingMagnetic,               withDouble: heading.magneticHeading)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            self.update(valueLocationCoordinateLatitude,    withDouble: location.coordinate.latitude)
            self.update(valueLocationCoordinateLongitude,   withDouble: location.coordinate.longitude)
            self.update(valueLocationAltitude,              withDouble: location.altitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return false
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
}
