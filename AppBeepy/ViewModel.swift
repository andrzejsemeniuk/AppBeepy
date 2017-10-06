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

class ViewModel {
    
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
            
            model.update                                .listener = { [weak self] value in
//                self?.build()
                self?.update.fire()
            }
            
            model.valueLocationCoordinateLatitude       .listener = listener
            model.valueLocationCoordinateLongitude      .listener = listener
            model.valueLocationAltitude                 .listener = listener
            
            build()
        }
    }
    
    var data            : Data = Data()
    
    var update          : BindingValue<Bool> = BindingValue<Bool>(false)
    
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
            
            rows.append(composeRowFromValue("LATITUDE",model.valueLocationCoordinateLatitude.value))
            rows.append(composeRowFromValue("LONGITUDE",model.valueLocationCoordinateLongitude.value))
            rows.append(composeRowFromValue("ALTITUDE",model.valueLocationAltitude.value))
            rows.append(composeRowFromValue("FLOOR",model.valueLocationFloor.value))
            rows.append(composeRowFromValue("ACCURACY/HORIZONTAL",model.valueLocationAccuracyHorizontal.value))
            rows.append(composeRowFromValue("ACCURACY/VERTICAL",model.valueLocationAccuracyVertical.value))
            rows.append(composeRowFromValue("TIMESTAMP",model.valueLocationTimestamp.value))
            rows.append(composeRowFromValue("SPEED",model.valueLocationSpeed.value))
            rows.append(composeRowFromValue("COURSE",model.valueLocationCourse.value))
            rows.append(composeRowFromValue("PLACEMARK",model.valueLocationPlacemark.value))

            data.sections.append(Section(title:"LOCATION", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [Row] = []
            
            rows.append(composeRowFromValue("MAGNETIC",model.valueHeadingMagnetic.value))
            rows.append(composeRowFromValue("TRUE",model.valueHeadingTrue.value))
            rows.append(composeRowFromValue("ACCURACY",model.valueHeadingAccuracy.value))
            rows.append(composeRowFromValue("TIMESTAMP",model.valueHeadingTimestamp.value))
            rows.append(composeRowFromValue("X",model.valueHeadingX.value))
            rows.append(composeRowFromValue("Y",model.valueHeadingY.value))
            rows.append(composeRowFromValue("Z",model.valueHeadingZ.value))

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
        
        self.data = data
    }
    
}
