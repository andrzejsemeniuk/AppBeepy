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

class BasicViewModel : ViewModel {
    
    internal var settings : Settings {
        return AppDelegate.settings
    }
    
    var model           : Model! {
        didSet {
            guard let model = model else { return }
            
            let listener : (ModelValue?)->() = { [weak self] value in
                self?.dirty.value = true
            }
            
            model.valueLocationCoordinateLatitude       .listener = listener
            model.valueLocationCoordinateLongitude      .listener = listener
            model.valueLocationAltitude                 .listener = listener
            model.valueLocationFloor                    .listener = listener
            model.valueLocationSpeed                    .listener = listener
            model.valueLocationCourse                   .listener = listener
            model.valueLocationPlacemark                .listener = listener
            model.valueLocationTimestamp                .listener = listener
            model.valueLocationAccuracyVertical         .listener = listener
            model.valueLocationAccuracyHorizontal       .listener = listener

            model.valueHeadingMagnetic                  .listener = listener
            model.valueHeadingTrue                      .listener = listener
            model.valueHeadingAccuracy                  .listener = listener
            model.valueHeadingTimestamp                 .listener = listener
            model.valueHeadingX                         .listener = listener
            model.valueHeadingY                         .listener = listener
            model.valueHeadingZ                         .listener = listener

            model.valueBeaconUUID                       .listener = listener
            model.valueBeaconMajor                      .listener = listener
            model.valueBeaconMinor                      .listener = listener
            model.valueBeaconIdentifier                 .listener = listener

            model.valueBeaconsRanged                    .listener = { [weak self] value in
                self?.dirty.value = true
            }

            model.valueRegionsRanged                    .listener = { [weak self] value in
                self?.dirty.value = true
            }
            
            model.valueRegionsMonitored                 .listener = { [weak self] value in
                self?.dirty.value = true
            }
            
            build()
        }
    }
    
    let dirty           = BindingValue<Bool>(false)
    
    var data            : ViewModelData {
        get {
            if let flag = dirty.value, flag {
                build()
                dirty.value = false
            }
            return _data
        }
    }

    private var _data   = ViewModelData()
    
    private func build() {
        
        guard let model = model else {
            return
        }
        
        let composeRowFromValue : (String,ModelValue?)->ViewModelRow = { title,value in
            if let value = value {
                return ViewModelRow(title:title, value:value.value ?? "?", changed:value.changed)
            }
            return ViewModelRow(title:title, value:"?")
        }
        
        var data = ViewModelData()
        
        if settings.settingLayoutShowLocation.value {
            var rows : [ViewModelRow] = []
            
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

            data.sections.append(ViewModelSection(title:"LOCATION", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [ViewModelRow] = []
            
            rows.append(composeRowFromValue("MAGNETIC",model.valueHeadingMagnetic.value))
            rows.append(composeRowFromValue("TRUE",model.valueHeadingTrue.value))
            rows.append(composeRowFromValue("ACCURACY",model.valueHeadingAccuracy.value))
            rows.append(composeRowFromValue("TIMESTAMP",model.valueHeadingTimestamp.value))
            rows.append(composeRowFromValue("X",model.valueHeadingX.value))
            rows.append(composeRowFromValue("Y",model.valueHeadingY.value))
            rows.append(composeRowFromValue("Z",model.valueHeadingZ.value))

            data.sections.append(ViewModelSection(title:"HEADING", rows: rows))
        }
        
        if settings.settingLayoutShowBeaconsRanged.value {
            var rows : [ViewModelRow] = []
            
            for (index,beacon) in (model.valueBeaconsRanged.value ?? []).enumerated() {
                
                rows.append(ViewModelRow(title:"BEACON",         value:"\(index)"))
                rows.append(ViewModelRow(title:"REGION",         value:beacon.regionIdentifier))
                rows.append(ViewModelRow(title:"PROXIMITY-UUID", value:beacon.proximityUUID))
                rows.append(ViewModelRow(title:"PROXIMITY",      value:"\(beacon.proximity.rawValue)"))
                rows.append(ViewModelRow(title:"ACCURACY",       value:"\(beacon.accuracy)"))
                rows.append(ViewModelRow(title:"MAJOR",          value:"\(beacon.major)"))
                rows.append(ViewModelRow(title:"MINOR",          value:"\(beacon.minor)"))
                rows.append(ViewModelRow(title:"RSSI",           value:"\(beacon.rssi)"))
            }

            data.sections.append(ViewModelSection(title:"RANGED BEACONS", rows: rows))
        }

        if settings.settingLayoutShowBeacon.value {
            var rows : [ViewModelRow] = []
            
            rows.append(composeRowFromValue("UUID",model.valueBeaconUUID.value))
            rows.append(composeRowFromValue("MAJOR",model.valueBeaconMajor.value))
            rows.append(composeRowFromValue("MINOR",model.valueBeaconMinor.value))
            rows.append(composeRowFromValue("IDENTIFIER",model.valueBeaconIdentifier.value))
            
            data.sections.append(ViewModelSection(title:"BEACON", rows: rows))
        }
        
        if settings.settingLayoutShowRegions.value {

            let createRegionRows : ([ModelValueRegion])->([ViewModelRow]) = { regions in
                var rows : [ViewModelRow] = []
                
                for (index,region) in regions.enumerated() {
                    rows.append(ViewModelRow(title:"REGION", value:"\(index)"))
                    rows.append(ViewModelRow(title:"IDENTIFIER", value:region.identifier))
                    rows.append(ViewModelRow(title:"STATE", value:region.state))
                }
                
                return rows
            }
            
            if settings.settingLayoutShowRegionsMonitored.value, let regions = model.valueRegionsMonitored.value {
                data.sections.append(ViewModelSection(title:"MONITORED REGIONS", rows: createRegionRows(regions)))
            }
            if settings.settingLayoutShowRegionsRanged.value, let regions = model.valueRegionsRanged.value {
                data.sections.append(ViewModelSection(title:"RANGED REGIONS", rows: createRegionRows(regions)))
            }

        }
        
        self._data = data
        
        self.dirty.value = false
    }
    
}
