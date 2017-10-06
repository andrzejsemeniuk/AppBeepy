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

struct ModelValue {
    
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

struct ModelValueRegion {
    let identifier          : String
    var state               : String = ""
    var notifyOnEntry       : Bool = false
    var notifyOnExit        : Bool = false
}

struct ModelValueBeacon {
    let regionIdentifier    : String
    let proximityUUID       : String
    let proximity           : CLProximity
    let accuracy            : Double
    let major               : UInt16
    let minor               : UInt16
    let rssi                : Int
}

protocol Model {
    
    var valueLocationCoordinateLatitude                 : BindingValue<ModelValue> { get }
    var valueLocationCoordinateLongitude                : BindingValue<ModelValue> { get }
    var valueLocationAltitude                           : BindingValue<ModelValue> { get }
    var valueLocationFloor                              : BindingValue<ModelValue> { get }
    var valueLocationAccuracyHorizontal                 : BindingValue<ModelValue> { get }
    var valueLocationAccuracyVertical                   : BindingValue<ModelValue> { get }
    var valueLocationTimestamp                          : BindingValue<ModelValue> { get }
    var valueLocationSpeed                              : BindingValue<ModelValue> { get }
    var valueLocationCourse                             : BindingValue<ModelValue> { get }
    var valueLocationPlacemark                          : BindingValue<ModelValue> { get }
    
    var valueHeadingMagnetic                            : BindingValue<ModelValue> { get }
    var valueHeadingTrue                                : BindingValue<ModelValue> { get }
    var valueHeadingAccuracy                            : BindingValue<ModelValue> { get }
    var valueHeadingTimestamp                           : BindingValue<ModelValue> { get }
    var valueHeadingX                                   : BindingValue<ModelValue> { get }
    var valueHeadingY                                   : BindingValue<ModelValue> { get }
    var valueHeadingZ                                   : BindingValue<ModelValue> { get }
    
    var valueBeaconUUID                                 : BindingValue<ModelValue> { get }
    var valueBeaconMajor                                : BindingValue<ModelValue> { get }
    var valueBeaconMinor                                : BindingValue<ModelValue> { get }
    var valueBeaconIdentifier                           : BindingValue<ModelValue> { get }
    
    var valueBeaconsRanged                              : BindingValue<[ModelValueBeacon]> { get }
    
    var valueRegionsMonitored                           : BindingValue<[ModelValueRegion]> { get }
    var valueRegionsRanged                              : BindingValue<[ModelValueRegion]> { get }
    
    var update                                          : BindingValue<Bool> { get }

}

class BasicModel : NSObject, Model {
    
    let valueLocationCoordinateLatitude                 = BindingValue<ModelValue>(ModelValue())
    let valueLocationCoordinateLongitude                = BindingValue<ModelValue>(ModelValue())
    let valueLocationAltitude                           = BindingValue<ModelValue>(ModelValue())
    let valueLocationFloor                              = BindingValue<ModelValue>(ModelValue())
    let valueLocationAccuracyHorizontal                 = BindingValue<ModelValue>(ModelValue())
    let valueLocationAccuracyVertical                   = BindingValue<ModelValue>(ModelValue())
    let valueLocationTimestamp                          = BindingValue<ModelValue>(ModelValue())
    let valueLocationSpeed                              = BindingValue<ModelValue>(ModelValue())
    let valueLocationCourse                             = BindingValue<ModelValue>(ModelValue())
    let valueLocationPlacemark                          = BindingValue<ModelValue>(ModelValue())
    
    let valueHeadingMagnetic                            = BindingValue<ModelValue>(ModelValue())
    let valueHeadingTrue                                = BindingValue<ModelValue>(ModelValue())
    let valueHeadingAccuracy                            = BindingValue<ModelValue>(ModelValue())
    let valueHeadingTimestamp                           = BindingValue<ModelValue>(ModelValue())
    let valueHeadingX                                   = BindingValue<ModelValue>(ModelValue())
    let valueHeadingY                                   = BindingValue<ModelValue>(ModelValue())
    let valueHeadingZ                                   = BindingValue<ModelValue>(ModelValue())
    
    let valueBeaconUUID                                 = BindingValue<ModelValue>(ModelValue())
    let valueBeaconMajor                                = BindingValue<ModelValue>(ModelValue())
    let valueBeaconMinor                                = BindingValue<ModelValue>(ModelValue())
    let valueBeaconIdentifier                           = BindingValue<ModelValue>(ModelValue())
    
    let valueBeaconsRanged                              = BindingValue<[ModelValueBeacon]>([])
    
    let valueRegionsMonitored                           = BindingValue<[ModelValueRegion]>([])
    let valueRegionsRanged                              = BindingValue<[ModelValueRegion]>([])
    
    let update                                          = BindingValue<Bool>(false)
    
    var locationManager : CLLocationManager!
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func update(_ value:BindingValue<ModelValue>!, withString:String) {
        if value.value?.set(fromString: withString) ?? false {
            value.fire()
        }
    }
    
    fileprivate func update(_ value:BindingValue<ModelValue>!, withDouble:Double) {
        if value.value?.set(fromDouble: withDouble) ?? false {
            value.fire()
        }
    }
}

extension BasicModel : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("deferred-updates-with-error: \(error)")
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // TODO
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ModelValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
        self.update.fire()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ModelValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ModelValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let heading = manager.heading {
            self.update(valueHeadingMagnetic,               withDouble: heading.magneticHeading)
            // TODO
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.update(valueLocationCoordinateLatitude,    withDouble: location.coordinate.latitude)
            self.update(valueLocationCoordinateLongitude,   withDouble: location.coordinate.longitude)
            self.update(valueLocationAltitude,              withDouble: location.altitude)
            // TODO
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            break
        case .notDetermined:
            fallthrough
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            fallthrough
        case .restricted:
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            manager.startMonitoringVisits()
        }
        
        self.update.fire()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        valueRegionsMonitored.value = manager.monitoredRegions.map {
            return ModelValueRegion(identifier: $0.identifier, state: "?", notifyOnEntry: false, notifyOnExit: false)
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let filtered = valueBeaconsRanged.value?.filter {
            return $0.regionIdentifier != region.identifier
            } ?? []
        valueBeaconsRanged.value = filtered + beacons.map {
            ModelValueBeacon(regionIdentifier    : region.identifier,
                             proximityUUID       : $0.proximityUUID.uuidString,
                             proximity           : $0.proximity,
                             accuracy            : $0.accuracy,
                             major               : UInt16($0.major),
                             minor               : UInt16($0.minor),
                             rssi                : $0.rssi)
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        self.update.fire()
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return false
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        // TODO: "LOCATION UPDATES: PAUSED"
        self.update.fire()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        self.update.fire()
    }
}

