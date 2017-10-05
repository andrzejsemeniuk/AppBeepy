//
//  Settings.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

/// This class contains all app settings.
class Settings : GenericManagerOfSettings {
    
    var flagFirstTime                                   = GenericSetting<Bool>          (key:"flag-first-time", first:true)
    
    var settingBackgroundColor                          = GenericSetting<UIColor>       (key:"setting-background", first:UIColor(hue:0.615))
    
    var settingAudioOn                                  = GenericSetting<Bool>          (key:"setting-audio-on", first:true)
    
    var settingDisplayHelp                              = GenericSetting<Bool>          (key:"setting-display-help", first:true)
    

    var settingLayoutShowLocation                       = GenericSetting<Bool>          (key:"setting-layout-show-location", first:true)
    // location/coordinate/latitude
    var settingLayoutShowLocationCoordinateLatitude     = GenericSetting<Bool>          (key:"setting-layout-show-location-coordinate-latitude", first:true)
    // location/coordinate/longitude
    var settingLayoutShowLocationCoordinateLongitude    = GenericSetting<Bool>          (key:"setting-layout-show-location-coordinate-longitude", first:true)
    // location/altitude
    var settingLayoutShowLocationAltitude               = GenericSetting<Bool>          (key:"setting-layout-show-location-altitude", first:true)
    // location/floor
    var settingLayoutShowLocationFloor                  = GenericSetting<Bool>          (key:"setting-layout-show-location-floor", first:true)
    // location/accuracy/horizontal
    var settingLayoutShowLocationAccuracyHorizontal     = GenericSetting<Bool>          (key:"setting-layout-show-location-accuracy-horizontal", first:true)
    // location/accuracy/vertical
    var settingLayoutShowLocationAccuracyVertical       = GenericSetting<Bool>          (key:"setting-layout-show-location-accuracy-vertical", first:true)
    // location/timestamp
    var settingLayoutShowLocationTimestamp              = GenericSetting<Bool>          (key:"setting-layout-show-location-timestamp", first:true)
    // location/speed
    var settingLayoutShowLocationSpeed                  = GenericSetting<Bool>          (key:"setting-layout-show-location-speed", first:true)
    // location/course
    var settingLayoutShowLocationCourse                 = GenericSetting<Bool>          (key:"setting-layout-show-location-course", first:true)
    // location/placemark
    var settingLayoutShowLocationPlacemark              = GenericSetting<Bool>          (key:"setting-layout-show-location-placemark", first:true)

    var settingLayoutShowHeading                        = GenericSetting<Bool>          (key:"setting-layout-show-heading", first:true)
    // heading/magnetic
    var settingLayoutShowHeadingMagnetic                = GenericSetting<Bool>          (key:"setting-layout-show-heading-magnetic", first:true)
    // heading/true
    var settingLayoutShowHeadingTrue                    = GenericSetting<Bool>          (key:"setting-layout-show-heading-true", first:true)
    // heading/accuracy
    var settingLayoutShowHeadingAccuracy                = GenericSetting<Bool>          (key:"setting-layout-show-heading-accuracy", first:true)
    // heading/timestamp
    var settingLayoutShowHeadingTimestamp               = GenericSetting<Bool>          (key:"setting-layout-show-heading-timestamp", first:true)
    // heading/x
    var settingLayoutShowHeadingX                       = GenericSetting<Bool>          (key:"setting-layout-show-heading-x", first:true)
    // heading/y
    var settingLayoutShowHeadingY                       = GenericSetting<Bool>          (key:"setting-layout-show-heading-y", first:true)
    // heading/z
    var settingLayoutShowHeadingZ                       = GenericSetting<Bool>          (key:"setting-layout-show-heading-z", first:true)

    var settingLayoutShowBeacon                         = GenericSetting<Bool>          (key:"setting-layout-show-beacon", first:true)
    // beacon/uuid
    var settingLayoutShowBeaconUUID                     = GenericSetting<Bool>          (key:"setting-layout-show-beacon-uuid", first:true)
    // beacon/major
    var settingLayoutShowBeaconMajor                    = GenericSetting<Bool>          (key:"setting-layout-show-beacon-major", first:true)
    // beacon/minor
    var settingLayoutShowBeaconMinor                    = GenericSetting<Bool>          (key:"setting-layout-show-beacon-minor", first:true)
    // beacon/id
    var settingLayoutShowBeaconId                       = GenericSetting<Bool>          (key:"setting-layout-show-beacon-id", first:true)

    var settingLayoutShowRegions                        = GenericSetting<Bool>          (key:"setting-layout-show-regions", first:true)
    // regions: monitored/ranged-beacons
    var settingLayoutShowRegionsMonitored               = GenericSetting<Bool>          (key:"setting-layout-show-regions-monitored", first:true)
    var settingLayoutShowRegionsRanged                  = GenericSetting<Bool>          (key:"setting-layout-show-regions-ranged", first:true)
    // region/identifier
    var settingLayoutShowRegionIdentifier               = GenericSetting<Bool>          (key:"setting-layout-show-region-identifier", first:true)
    // region/state
    var settingLayoutShowRegionState                    = GenericSetting<Bool>          (key:"setting-layout-show-region-state", first:true)
    // region/notify-on-entry/exit
    var settingLayoutShowRegionNotification             = GenericSetting<Bool>          (key:"setting-layout-show-region-notification", first:true)

    
    var settingBeaconTransmitterUUID                    = GenericSetting<String>        (key:"setting-beacon-transmitter-uuid", first:"")
    var settingBeaconTransmitterMajor                   = GenericSetting<UInt16>        (key:"setting-beacon-transmitter-major", first:0)
    var settingBeaconTransmitterMinor                   = GenericSetting<UInt16>        (key:"setting-beacon-transmitter-minor", first:0)
    var settingBeaconTransmitterIdentifier              = GenericSetting<String>        (key:"setting-beacon-transmitter-identifier", first:"?")

    
    /// Use this method to store settings persistently.
    func synchronize() {
        UserDefaults.standard.synchronize()
        
        AppDelegate.synchronizeWithSettings()
    }
    
    func configurationLoadCurrent() {
        
    }
    
}
