//
//  Model.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/5/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth
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
        
        locationManager.requestAlwaysAuthorization()
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
    
    
    
    
    
    func storedBeaconsAdd           (_ beacon:StoredBeacon) {
        settings.settingStoredBeacons.value = settings.settingStoredBeacons.value.appended(with:beacon.encoded,delimiter:delimiterOfModelRecord)
        self.monitoringStart(on: beacon)
    }
    func storedBeaconsRemove        (withIdentifier identifier:String) {
        settings.settingStoredBeacons.value = settings.settingStoredBeacons.value.split(delimiterOfModelRecord).filter { [weak self] in
            let stored = StoredBeacon(fromString:$0)
            if stored.identifier == identifier {
                self?.monitoringStop(on: stored)
                return false
            }
            return true
            }.joined(separator:delimiterOfModelRecord)
    }
    func storedBeaconsGet           () -> [StoredBeacon] {
        return settings.settingStoredBeacons.value.split(delimiterOfModelRecord).filter { !$0.isEmpty }.map {
            return StoredBeacon.init(fromString: $0)
        }
    }
    func monitoringStart    (on beacon:StoredBeacon) -> Bool {
        if let uuid = UUID(uuidString: beacon.UUID) {
            let region = CLBeaconRegion(proximityUUID   : uuid,
                                        major           : beacon.major,
                                        minor           : beacon.minor,
                                        identifier      : beacon.identifier)
            
            self.locationManager?.startMonitoring(for: region)
            self.locationManager?.startRangingBeacons(in: region)
            self.advertiseDevice(region: region)
            return true
        }
        return false
    }
    func monitoringStop     (on beacon:StoredBeacon) -> Bool {
        if let uuid = UUID(uuidString: beacon.UUID) {
            let region = CLBeaconRegion(proximityUUID   : uuid,
                                        major           : beacon.major,
                                        minor           : beacon.minor,
                                        identifier      : beacon.identifier)
            
            self.locationManager?.stopMonitoring(for: region)
            self.locationManager?.stopRangingBeacons(in: region)
            return true
        }
        return false
    }
    func storedBeaconsMonitoringStart   () {
        self.storedBeaconsGet().forEach {
            _ = monitoringStart(on: $0)
        }
    }
    func storedBeaconsMonitoringStop   () {
        self.storedBeaconsGet().forEach {
            _ = monitoringStop(on: $0)
        }
    }
    func advertiseDevice(region : CLBeaconRegion) {
        let peripheral = CBPeripheralManager(delegate: self, queue: nil)
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        
        peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }
    
    
    
    func storedRegionBeaconsAdd           (_ beacon:StoredRegionForBeacon) {
        settings.settingStoredRegionsOfBeacon.value = settings.settingStoredRegionsOfBeacon.value.appended(with:beacon.encoded,delimiter:delimiterOfModelRecord)
        self.monitoringStart(on: beacon)
    }
    func storedRegionBeaconsRemove        (withIdentifier identifier:String) {
        settings.settingStoredRegionsOfBeacon.value = settings.settingStoredRegionsOfBeacon.value.split(delimiterOfModelRecord).filter { [weak self] in
            let stored = StoredRegionForBeacon(fromString:$0)
            if stored.identifier == identifier {
                self?.monitoringStop(on: stored)
                return false
            }
            return true
            }.joined(separator:delimiterOfModelRecord)
    }
    func storedRegionBeaconsGet           () -> [StoredRegionForBeacon] {
        return settings.settingStoredRegionsOfBeacon.value.split(delimiterOfModelRecord).filter { !$0.isEmpty }.map {
            return StoredRegionForBeacon.init(fromString: $0)
        }
    }
    func monitoringStart                  (on beacon:StoredRegionForBeacon) -> Bool {
        if let uuid = UUID(uuidString: beacon.UUID) {
            let region = CLBeaconRegion(proximityUUID   : uuid,
                                        identifier      : beacon.identifier)
            
            self.locationManager?.startMonitoring(for: region)
            self.locationManager?.startRangingBeacons(in: region)
            return true
        }
        return false
    }
    func monitoringStop                   (on beacon:StoredRegionForBeacon) -> Bool {
        if let uuid = UUID(uuidString: beacon.UUID) {
            let region = CLBeaconRegion(proximityUUID   : uuid,
                                        identifier      : beacon.identifier)
            
            self.locationManager?.stopMonitoring(for: region)
            self.locationManager?.stopRangingBeacons(in: region)
            return true
        }
        return false
    }
    func storedRegionBeaconsMonitoringStart   () {
        self.storedRegionBeaconsGet().forEach {
            _ = monitoringStart(on: $0)
        }
    }
    func storedRegionBeaconsMonitoringStop   () {
        self.storedRegionBeaconsGet().forEach {
            _ = monitoringStop(on: $0)
        }
    }
    
    
    
    
    
    func storedRegionLocationsAdd         (_ beacon:StoredRegionForLocation) {
        settings.settingStoredRegionsOfLocation.value = settings.settingStoredRegionsOfLocation.value.appended(with:beacon.encoded,delimiter:delimiterOfModelRecord)
        self.monitoringStart(on: beacon)
    }
    func storedRegionLocationsRemove      (withIdentifier identifier:String) {
        settings.settingStoredRegionsOfLocation.value = settings.settingStoredRegionsOfLocation.value.split(delimiterOfModelRecord).filter { [weak self] in
            let stored = StoredRegionForLocation(fromString:$0)
            if stored.identifier == identifier {
                self?.monitoringStop(on: stored)
                return false
            }
            return true
            }.joined(separator:delimiterOfModelRecord)
    }
    func storedRegionLocationsGet         () -> [StoredRegionForLocation] {
        return settings.settingStoredRegionsOfLocation.value.split(delimiterOfModelRecord).filter { !$0.isEmpty }.map {
            return StoredRegionForLocation.init(fromString: $0)
        }
    }
    func monitoringStart                  (on region:StoredRegionForLocation) -> Bool {
        let region = CLCircularRegion(center    : CLLocationCoordinate2D.init(latitude: region.latitude, longitude: region.longitude),
                                      radius    : region.radius,
                                      identifier: region.identifier)
        self.locationManager?.startMonitoring(for: region)
        return true
    }
    func monitoringStop                   (on region:StoredRegionForLocation) -> Bool {
        let region = CLCircularRegion(center    : CLLocationCoordinate2D.init(latitude: region.latitude, longitude: region.longitude),
                                      radius    : region.radius,
                                      identifier: region.identifier)
        self.locationManager?.stopMonitoring(for: region)
        return true
    }
    func storedRegionLocationsMonitoringStart   () {
        self.storedRegionLocationsGet().forEach {
            _ = monitoringStart(on: $0)
        }
    }
    func storedRegionLocationsMonitoringStop   () {
        self.storedRegionLocationsGet().forEach {
            _ = monitoringStop(on: $0)
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
            
            self.storedBeaconsMonitoringStart()
            self.storedRegionBeaconsMonitoringStart()
            self.storedRegionLocationsMonitoringStart()
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
        if beacons.isNotEmpty {
            let filtered = valueBeaconsRanged.value?.filter {
                return $0.regionIdentifier != region.identifier
                } ?? []
            valueBeaconsRanged.value = filtered + beacons.map {
                ModelValueBeacon(regionIdentifier    : region.identifier,
                                 proximityUUID       : $0.proximityUUID.uuidString,
                                 proximity           : $0.proximity,
                                 accuracy            : $0.accuracy,
                                 major               : CLBeaconMajorValue($0.major),
                                 minor               : CLBeaconMinorValue($0.minor),
                                 rssi                : $0.rssi)
            }
            self.update.fire()
        }
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

extension BasicModel : CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOff:
            fallthrough
        case .poweredOn:
            fallthrough
        case .resetting:
            fallthrough
        case .unauthorized:
            fallthrough
        case .unknown:
            fallthrough
        case .unsupported:
            fallthrough
        default:
            print("peripheral state:\(peripheral.state)")
        }
    }
    
    
}

