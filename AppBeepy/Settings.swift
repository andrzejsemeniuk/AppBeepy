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
    
    
    
    var settingColorBackground                          = GenericSetting<UIColor>       (key:"setting-color-background", first:UIColor(hue:0.615))
    var settingColorBackgroundSettings                  = GenericSetting<UIColor>       (key:"setting-color-background-settings", first:UIColor(white:0.96))
    var settingColorText                                = GenericSetting<UIColor>       (key:"setting-color-text", first:.white)
    var settingColorTitle                               = GenericSetting<UIColor>       (key:"setting-color-title", first:.white)

    var settingFontName                                 = GenericSetting<String>        (key:"setting-font-name", first:"GillSans-Light")
    var settingFontTitleName                            = GenericSetting<String>        (key:"setting-font-name-title", first:"GillSans")

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
    

    var settingLayout                                   = GenericSetting<String>        (key:"setting-layout", first:"")
    var settingLayoutElements                           : [String] {
        return settingLayout.value.split(",")
    }
    func settingLayoutRebuild                           () {
        var elements:[String] = []
        for element in collect(withPrefix:"settingLayoutShow") {
            if let setting = element.object as? GenericSetting<Bool>, setting.value {
                elements.append(setting.key)
            }
        }
        settingLayout.value = elements.joined(separator: ",")
    }
    func settingLayoutElements                          (append id:String) {
        var list = self.settingLayoutElements.filter { $0 != id }
        list.append(id)
        settingLayout.value = list.joined(separator:",")
    }
    func settingLayoutElements                          (remove id:String) {
        let list = self.settingLayoutElements.filter { $0 != id }
        settingLayout.value = list.joined(separator:",")
    }


    
    var settingBeaconTransmitterUUID                    = GenericSetting<String>        (key:"setting-beacon-transmitter-uuid", first:"")
    var settingBeaconTransmitterMajor                   = GenericSetting<UInt16>        (key:"setting-beacon-transmitter-major", first:0)
    var settingBeaconTransmitterMinor                   = GenericSetting<UInt16>        (key:"setting-beacon-transmitter-minor", first:0)
    var settingBeaconTransmitterIdentifier              = GenericSetting<String>        (key:"setting-beacon-transmitter-identifier", first:"?")

    
    
    
    var configurationCurrent                            = GenericSetting<String>        (key:"configuration-current", first: "Default")
    var configurationListPredefined                     = GenericSetting<String>        (key:"configuration-list-predefined", first:"Default,All")
    var configurationCustomStorage                      = GenericSetting<Dictionary<String,Dictionary<String,Any>>> (key:"configuration-list-custom-storage", first:[:])
    var configurationArrayOfNamesPredefined             : [String] {
        return configurationListPredefined.value.split(",").sorted()
    }
    var configurationArrayOfNamesCustom                 : [String] {
        return configurationCustomStorage.value.keys.sorted()
    }

    
    
    
    /// Use this method to store settings persistently.
    func synchronize() {
        UserDefaults.standard.synchronize()
        
        AppDelegate.synchronizeWithSettings()
    }
    
}

// MARK: - CONFIGURATIONS

extension Settings {
    
    /// Engage current configuration
    func configurationLoadCurrent() {
        self.configuration(loadWithName: configurationCurrent.value)
    }
    
    /// Engage the specified configuration
    ///
    /// - Parameter name: the name of the configuration to engage
    func configuration(loadWithName name:String) {
        
        let clear = {
            self.reset(withPrefix:"setting")
            
        }
        
        let name = name.trimmed()
        
        switch name {
            
        case "Default":
            
            clear()
            
            configurationCurrent                            .value = name
            
            synchronize()
            
        case "All":
            
            clear()
            
            configurationCurrent                            .value = name
            
            for setting in self.collect(withPrefix:"settingLayoutShow") {
                if let setting = setting.object as? GenericSetting<Bool> {
                    setting.value = true
                }
            }
            
            synchronize()
            
        default:
            
            if let dictionary = configurationCustomStorage.value[name] {
                
                print(dictionary)
                
                clear()
                
                configurationCurrent.value = name
                
                decode(dictionary: dictionary, withPrefix:"setting") // only interested in 'setting' variables
                
                synchronize()
            }
            
            break
        }
    }
    
    /// Save current configuration with a custom name as a new configuration
    ///
    /// - Parameter name: name of new configuration
    /// - Returns: true if saved
    func configuration(saveWithCustomName name:String) -> Bool {
        
        if !configurationArrayOfNamesPredefined.contains(name) {
            
            var dictionary = [String:Any]()
            
            settingLayoutRebuild()
            
            encode(dictionary: &dictionary, withPrefix:"setting") // only interested in 'setting' variables
            
            print(dictionary)
            
            var current = configurationCustomStorage.value
            
            current[name] = dictionary
            
            configurationCustomStorage.value = current
            
            synchronize()
            
            return true
        }
        
        return false
    }
    
    /// Remove custom configuration with specified name
    ///
    /// - Parameter name: name of custom configuration to remove
    /// - Returns: true if success
    func configuration(removeCustomWithName name:String) -> Bool {
        
        if configurationArrayOfNamesCustom.contains(name) {
            
            var current = configurationCustomStorage.value
            
            current.removeValue(forKey: name)
            
            configurationCustomStorage.value = current
            
            synchronize()
            
            return true
        }
        return false
    }
    
}
