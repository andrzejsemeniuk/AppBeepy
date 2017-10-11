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

let delimiterOfModelRecord = "\u{1}"
let delimiterOfModelField  = "\u{2}"


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
    let major               : CLBeaconMajorValue
    let minor               : CLBeaconMinorValue
    let rssi                : Int
}

struct StoredBeacon {
    var UUID        : String = ""
    var major       : CLBeaconMajorValue = 0
    var minor       : CLBeaconMinorValue = 0
    var identifier  : String = ""
    
    init() {}
    init(fromString string:String) {
        let elements    = string.split(delimiterOfModelField)
        self.UUID       = elements[safe:0] ?? "?"
        self.major      = CLBeaconMajorValue(elements[safe:1] ?? "0") ?? 0
        self.minor      = CLBeaconMinorValue(elements[safe:2] ?? "0") ?? 0
        self.identifier = elements[safe:3] ?? "?"
    }
    
    var encoded:String {
        return "\(UUID)\(delimiterOfModelField)\(major)\(delimiterOfModelField)\(minor)\(delimiterOfModelField)\(identifier)"
    }
}

struct StoredRegionForBeacon {
    var UUID        : String = ""
    var identifier  : String = ""
    
    init() {}
    init(fromString string:String) {
        let elements    = string.split(delimiterOfModelField)
        self.UUID       = elements[safe:0] ?? "?"
        self.identifier = elements[safe:1] ?? "?"
    }
    
    var encoded:String {
        return "\(UUID)\(delimiterOfModelField)\(identifier)"
    }
}

struct StoredRegionForLocation {
    var latitude    : CLLocationDegrees   = 0
    var longitude   : CLLocationDegrees   = 0
    var radius      : CLLocationDistance  = 0
    var identifier  : String              = ""
    
    init() {}
    init(fromString string:String) {
        let elements    = string.split(delimiterOfModelField)
        self.latitude   = Double(elements[safe:0] ?? "0") ?? 0
        self.longitude  = Double(elements[safe:1] ?? "0") ?? 0
        self.radius     = Double(elements[safe:2] ?? "0") ?? 0
        self.identifier = elements[safe:1] ?? "?"
    }
    
    var encoded:String {
        return "\(latitude)\(delimiterOfModelField)\(longitude)\(delimiterOfModelField)\(radius)\(delimiterOfModelField)\(identifier)"
    }
}

protocol Model : class {
    
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

    
    func storedBeaconsAdd                               (_ beacon:StoredBeacon)
    func storedBeaconsRemove                            (withIdentifier:String)
    func storedBeaconsGet                               () -> [StoredBeacon]
    
    
    func storedRegionBeaconsAdd                         (_ beacon:StoredRegionForBeacon)
    func storedRegionBeaconsRemove                      (withIdentifier:String)
    func storedRegionBeaconsGet                         () -> [StoredRegionForBeacon]
    
    
    func storedRegionLocationsAdd                       (_ beacon:StoredRegionForLocation)
    func storedRegionLocationsRemove                    (withIdentifier:String)
    func storedRegionLocationsGet                       () -> [StoredRegionForLocation]

}
