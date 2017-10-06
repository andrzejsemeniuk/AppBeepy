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
    
    struct ValueRegion {
        let identifier          : String
        var state               : String = ""
        var notifyOnEntry       : Bool = false
        var notifyOnExit        : Bool = false
    }
    
    struct ValueBeacon {
        let regionIdentifier    : String
        let proximityUUID       : String
        let proximity           : CLProximity
        let accuracy            : Double
        let major               : UInt16
        let minor               : UInt16
        let rssi                : Int
    }
    
    var valueLocationCoordinateLatitude                 = BindingValue<Value>(Value())
    var valueLocationCoordinateLongitude                = BindingValue<Value>(Value())
    var valueLocationAltitude                           = BindingValue<Value>(Value())
    var valueLocationFloor                              = BindingValue<Value>(Value())
    var valueLocationAccuracyHorizontal                 = BindingValue<Value>(Value())
    var valueLocationAccuracyVertical                   = BindingValue<Value>(Value())
    var valueLocationTimestamp                          = BindingValue<Value>(Value())
    var valueLocationSpeed                              = BindingValue<Value>(Value())
    var valueLocationCourse                             = BindingValue<Value>(Value())
    var valueLocationPlacemark                          = BindingValue<Value>(Value())

    var valueHeadingMagnetic                            = BindingValue<Value>(Value())
    var valueHeadingTrue                                = BindingValue<Value>(Value())
    var valueHeadingAccuracy                            = BindingValue<Value>(Value())
    var valueHeadingTimestamp                           = BindingValue<Value>(Value())
    var valueHeadingX                                   = BindingValue<Value>(Value())
    var valueHeadingY                                   = BindingValue<Value>(Value())
    var valueHeadingZ                                   = BindingValue<Value>(Value())

    var valueBeaconUUID                                 = BindingValue<Value>(Value())
    var valueBeaconMajor                                = BindingValue<Value>(Value())
    var valueBeaconMinor                                = BindingValue<Value>(Value())
    var valueBeaconIdentifier                           = BindingValue<Value>(Value())
    
    var valueBeaconsRanged                              = BindingValue<[ValueBeacon]>([])
    
    var valueRegionsMonitored                           = BindingValue<[ValueRegion]>([])
    var valueRegionsRanged                              = BindingValue<[ValueRegion]>([])

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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // TODO
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let filtered = valueBeaconsRanged.value?.filter {
            return $0.regionIdentifier != region.identifier
        } ?? []
        valueBeaconsRanged.value = filtered + beacons.map {
            ValueBeacon(regionIdentifier    : region.identifier,
                        proximityUUID       : $0.proximityUUID.uuidString,
                        proximity           : $0.proximity,
                        accuracy            : $0.accuracy,
                        major               : UInt16($0.major),
                        minor               : UInt16($0.minor),
                        rssi                : $0.rssi)
        }
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
