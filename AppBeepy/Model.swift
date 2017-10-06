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
