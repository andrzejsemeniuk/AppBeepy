//
//  ViewModel.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import CoreLocation
import ASToolkit

class ViewModelOfDashboard {
    
    internal var settings : Settings {
        return AppDelegate.settings
    }

    struct Section {
        let title       : String
        var rows        : [Row] = []
    }
    
    struct Row {
        let title       : String
        let value       : String
        let changed     : Bool
        
        init(title:String, value:String, changed:Bool = false) {
            self.title = title
            self.value = value
            self.changed = changed
        }
    }
    
    struct Data {
        var sections    : [Section] = []
    }
    
    var model           : Model! {
        didSet {
            guard let model = model else { return }
            
            let listener : (Model.Value?)->() = { [weak self] value in
                self?.build()
            }
            
            model.valueLocationCoordinateLatitude       .listener = listener
            model.valueLocationCoordinateLongitude      .listener = listener
            model.valueLocationAltitude                 .listener = listener
            
            build()
        }
    }
    
    var data            : BindingValue<Data> = BindingValue<Data>()
    
    func build() {
        
        guard let model = model else {
            return
        }
        
        let composeRowFromValue : (String,Model.Value?)->Row = { title,value in
            if let value = value {
                return Row(title:title, value:value.value ?? "?", changed:value.changed)
            }
            return Row(title:title, value:"?")
        }
        
        var data = Data()
        
        if settings.settingLayoutShowLocation.value {
            var rows : [Row] = []
            
            if true || settings.settingLayoutShowLocationCoordinateLatitude.value {
                rows.append(composeRowFromValue("LATITUDE",model.valueLocationCoordinateLatitude.value))
            }
            if true || settings.settingLayoutShowLocationCoordinateLongitude.value {
                rows.append(composeRowFromValue("LONGITUDE",model.valueLocationCoordinateLongitude.value))
            }
            if true || settings.settingLayoutShowLocationAltitude.value {
                rows.append(composeRowFromValue("ALTITUDE",model.valueLocationAltitude.value))
            }
            if true || settings.settingLayoutShowLocationFloor.value {
                rows.append(composeRowFromValue("FLOOR",model.valueLocationFloor.value))
            }
            if true || settings.settingLayoutShowLocationAccuracyHorizontal.value {
                rows.append(composeRowFromValue("ACCURACY/H",model.valueLocationAccuracyHorizontal.value))
            }
            if true || settings.settingLayoutShowLocationAccuracyVertical.value {
                rows.append(composeRowFromValue("ACCURACY/H",model.valueLocationAccuracyVertical.value))
            }
            if true || settings.settingLayoutShowLocationTimestamp.value {
                rows.append(composeRowFromValue("TIMESTAMP",model.valueLocationTimestamp.value))
            }
            if true || settings.settingLayoutShowLocationSpeed.value {
                rows.append(composeRowFromValue("SPEED",model.valueLocationSpeed.value))
            }
            if true || settings.settingLayoutShowLocationCourse.value {
                rows.append(composeRowFromValue("COURSE",model.valueLocationCourse.value))
            }
            if true || settings.settingLayoutShowLocationPlacemark.value {
                rows.append(composeRowFromValue("PLACEMARK",model.valueLocationPlacemark.value))
            }

            data.sections.append(Section(title:"LOCATION", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [Row] = []
            
            if true || settings.settingLayoutShowHeadingMagnetic.value {
                rows.append(composeRowFromValue("MAGNETIC",model.valueHeadingMagnetic.value))
            }
            if true || settings.settingLayoutShowHeadingTrue.value {
                rows.append(composeRowFromValue("TRUE",model.valueHeadingTrue.value))
            }
            if true || settings.settingLayoutShowHeadingAccuracy.value {
                rows.append(composeRowFromValue("ACCURACY",model.valueHeadingAccuracy.value))
            }
            if true || settings.settingLayoutShowHeadingTimestamp.value {
                rows.append(composeRowFromValue("TIMESTAMP",model.valueHeadingTimestamp.value))
            }
            if true || settings.settingLayoutShowHeadingX.value {
                rows.append(composeRowFromValue("X",model.valueHeadingX.value))
            }
            if true || settings.settingLayoutShowHeadingY.value {
                rows.append(composeRowFromValue("Y",model.valueHeadingY.value))
            }
            if true || settings.settingLayoutShowHeadingZ.value {
                rows.append(composeRowFromValue("Z",model.valueHeadingZ.value))
            }

            data.sections.append(Section(title:"HEADING", rows: rows))
        }
        
        if settings.settingLayoutShowBeaconsRanged.value {
            var rows : [Row] = []
            
            for (index,beacon) in (model.valueBeaconsRanged.value ?? []).enumerated() {
                
                rows.append(Row(title:"BEACON",         value:"\(index)"))
                rows.append(Row(title:"REGION",         value:beacon.regionIdentifier))
                rows.append(Row(title:"PROXIMITY-UUID", value:beacon.proximityUUID))
                rows.append(Row(title:"PROXIMITY",      value:"\(beacon.proximity.rawValue)"))
                rows.append(Row(title:"ACCURACY",       value:"\(beacon.accuracy)"))
                rows.append(Row(title:"MAJOR",          value:"\(beacon.major)"))
                rows.append(Row(title:"MINOR",          value:"\(beacon.minor)"))
                rows.append(Row(title:"RSSI",           value:"\(beacon.rssi)"))
            }

            data.sections.append(Section(title:"RANGED BEACONS", rows: rows))
        }

        if settings.settingLayoutShowBeacon.value {
            var rows : [Row] = []
            
            rows.append(composeRowFromValue("UUID",model.valueBeaconUUID.value))
            rows.append(composeRowFromValue("MAJOR",model.valueBeaconMajor.value))
            rows.append(composeRowFromValue("MINOR",model.valueBeaconMinor.value))
            rows.append(composeRowFromValue("IDENTIFIER",model.valueBeaconIdentifier.value))
            
            data.sections.append(Section(title:"BEACON", rows: rows))
        }
        
        if settings.settingLayoutShowRegions.value {

            let createRegionRows : ([Model.ValueRegion])->([Row]) = { regions in
                var rows : [Row] = []
                
                for (index,region) in regions.enumerated() {
                    rows.append(Row(title:"REGION", value:"\(index)"))
                    rows.append(Row(title:"IDENTIFIER", value:region.identifier))
                    rows.append(Row(title:"STATE", value:region.state))
                }
                
                return rows
            }
            
            if settings.settingLayoutShowRegionsMonitored.value, let regions = model.valueRegionsMonitored.value {
                data.sections.append(Section(title:"MONITORED REGIONS", rows: createRegionRows(regions)))
            }
            if settings.settingLayoutShowRegionsRanged.value, let regions = model.valueRegionsRanged.value {
                data.sections.append(Section(title:"RANGED REGIONS", rows: createRegionRows(regions)))
            }

        }
        
        self.data.value = data
    }
}
