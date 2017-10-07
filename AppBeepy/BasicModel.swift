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


class BasicModel : NSObject, Model {
    
    internal var settings : Settings {
        return AppDelegate.settings
    }
    
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
    
    
    
    
    
    
    struct Beacon {
        var UUID        : String
        var major       : UInt16
        var minor       : UInt16
        var identifier  : String
        
        init(fromString string:String) {
            let elements    = string.split("|")
            self.UUID       = elements[safe:0]?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "|", with: "") ?? "?"
            self.major      = UInt16(elements[safe:1] ?? "0") ?? 0
            self.minor      = UInt16(elements[safe:2] ?? "0") ?? 0
            self.identifier = elements[safe:3]?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "|", with: "") ?? "?"
        }
        
        var encoded:String {
            return "\(UUID)|\(major)|\(minor)|\(identifier)"
        }
    }
    func storedBeaconsAdd           (_ beacon:Beacon) {
        settings.settingStoredBeacons.value = settings.settingStoredBeacons.value.appended(with:beacon.encoded,delimiter:"%")
    }
    func storedBeaconsRemove        (withUUID:String) {
        settings.settingStoredBeacons.value = settings.settingStoredBeacons.value.split("%").filter {
            if let uuid = $0.split("|")[safe:0], uuid == withUUID {
                return false
            }
            return true
            }.joined(separator:"%")
    }
    func storedBeaconsGet           () -> [Beacon] {
        return settings.settingStoredBeacons.value.split("%").map {
            return Beacon.init(fromString: $0)
        }
    }
    
    
    
    
    struct RegionForBeacon {
        var UUID        : String
        var identifier  : String

        init(fromString string:String) {
            let elements    = string.split("|")
            self.UUID       = elements[safe:0]?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "|", with: "") ?? "?"
            self.identifier = elements[safe:1]?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "|", with: "") ?? "?"
        }
        
        var encoded:String {
            return "\(UUID)|\(identifier)"
        }
    }
    func regionBeaconsAdd           (_ beacon:RegionForBeacon) {
        settings.settingStoredBeaconRegions.value = settings.settingStoredBeaconRegions.value.appended(with:beacon.encoded,delimiter:"%")
    }
    func regionBeaconsRemove        (withUUID:String) {
        settings.settingStoredBeaconRegions.value = settings.settingStoredBeaconRegions.value.split("%").filter {
            if let uuid = $0.split("|")[safe:0], uuid == withUUID {
                return false
            }
            return true
            }.joined(separator:"%")
    }
    func regionBeaconsGet           () -> [RegionForBeacon] {
        return settings.settingStoredBeaconRegions.value.split("%").map {
            return RegionForBeacon.init(fromString: $0)
        }
    }
    


    
    
    struct RegionForLocation {
        var latitude    : CLLocationDegrees
        var longitude   : CLLocationDegrees
        var radius      : CLLocationDistance
        var identifier  : String
        
        init(fromString string:String) {
            let elements    = string.split("|")
            self.latitude   = Double(elements[safe:0] ?? "0") ?? 0
            self.longitude  = Double(elements[safe:1] ?? "0") ?? 0
            self.radius     = Double(elements[safe:2] ?? "0") ?? 0
            self.identifier = elements[safe:1]?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: "|", with: "") ?? "?"
        }
        
        var encoded:String {
            return "\(latitude)|\(longitude)|\(radius)|\(identifier)"
        }
    }
    func regionLocationsAdd         (_ beacon:RegionForBeacon) {
        settings.settingStoredGeoRegions.value = settings.settingStoredGeoRegions.value.appended(with:beacon.encoded,delimiter:"%")
    }
    func regionLocationsRemove      (withUUID:String) {
        settings.settingStoredGeoRegions.value = settings.settingStoredGeoRegions.value.split("%").filter {
            if let uuid = $0.split("|")[safe:0], uuid == withUUID {
                return false
            }
            return true
            }.joined(separator:"%")
    }
    func regionLocationsGet         () -> [RegionForBeacon] {
        return settings.settingStoredGeoRegions.value.split("%").map {
            return RegionForBeacon.init(fromString: $0)
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
            self.update(valueHeadingTrue,                   withDouble: heading.trueHeading)
            self.update(valueHeadingAccuracy,               withDouble: heading.headingAccuracy)
            self.update(valueHeadingTimestamp,              withString: "\(heading.timestamp)")
            self.update(valueHeadingX,                      withDouble: heading.x)
            self.update(valueHeadingY,                      withDouble: heading.y)
            self.update(valueHeadingZ,                      withDouble: heading.z)
        }
        self.update.fire()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.update(valueLocationCoordinateLatitude,    withDouble: location.coordinate.latitude)
            self.update(valueLocationCoordinateLongitude,   withDouble: location.coordinate.longitude)
            self.update(valueLocationAltitude,              withDouble: location.altitude)
            self.update(valueLocationAccuracyHorizontal,    withDouble: location.horizontalAccuracy)
            self.update(valueLocationAccuracyVertical,      withDouble: location.verticalAccuracy)
            self.update(valueLocationTimestamp,             withString: "\(location.timestamp)")
            //            self.update(valueLocationPlacemark,              withDouble: location.)
            self.update(valueLocationCourse,                withDouble: location.course)
            self.update(valueLocationSpeed,                 withDouble: location.speed)
            self.update(valueLocationFloor,                 withString: "\(location.floor?.level ?? -1)")
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
            manager.requestLocation()
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            manager.startMonitoringVisits()
            manager.pausesLocationUpdatesAutomatically=false
            manager.disallowDeferredLocationUpdates()
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

