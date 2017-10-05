//
//  ViewModel.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
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
            return Row(title:title, value:"?", changed:false)
        }
        
        var data = Data()
        
        if settings.settingLayoutShowLocation.value {
            var rows : [Row] = []
            
            if settings.settingLayoutShowLocationCoordinateLatitude.value {
                rows.append(composeRowFromValue("LATITUDE",model.valueLocationCoordinateLatitude.value))
            }
            if settings.settingLayoutShowLocationCoordinateLongitude.value {
                rows.append(composeRowFromValue("LONGITUDE",model.valueLocationCoordinateLongitude.value))
            }
            if settings.settingLayoutShowLocationAltitude.value {
                rows.append(composeRowFromValue("ALTITUDE",model.valueLocationAltitude.value))
            }
            if settings.settingLayoutShowLocationFloor.value {
                rows.append(composeRowFromValue("FLOOR",model.valueLocationFloor.value))
            }
            if settings.settingLayoutShowLocationAccuracyHorizontal.value {
                rows.append(composeRowFromValue("ACCURACY/H",model.valueLocationAccuracyHorizontal.value))
            }
            if settings.settingLayoutShowLocationAccuracyVertical.value {
                rows.append(composeRowFromValue("ACCURACY/H",model.valueLocationAccuracyVertical.value))
            }
            if settings.settingLayoutShowLocationTimestamp.value {
                rows.append(composeRowFromValue("TIMESTAMP",model.valueLocationTimestamp.value))
            }
            if settings.settingLayoutShowLocationSpeed.value {
                rows.append(composeRowFromValue("SPEED",model.valueLocationSpeed.value))
            }
            if settings.settingLayoutShowLocationCourse.value {
                rows.append(composeRowFromValue("COURSE",model.valueLocationCourse.value))
            }
            if settings.settingLayoutShowLocationPlacemark.value {
                rows.append(composeRowFromValue("PLACEMARK",model.valueLocationPlacemark.value))
            }

            data.sections.append(Section(title:"LOCATION", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [Row] = []
            
            if settings.settingLayoutShowHeadingMagnetic.value {
                rows.append(composeRowFromValue("MAGNETIC",model.valueHeadingMagnetic.value))
            }
            if settings.settingLayoutShowHeadingTrue.value {
                rows.append(composeRowFromValue("TRUE",model.valueHeadingTrue.value))
            }
            if settings.settingLayoutShowHeadingAccuracy.value {
                rows.append(composeRowFromValue("ACCURACY",model.valueHeadingAccuracy.value))
            }
            if settings.settingLayoutShowHeadingTimestamp.value {
                rows.append(composeRowFromValue("TIMESTAMP",model.valueHeadingTimestamp.value))
            }
            if settings.settingLayoutShowHeadingX.value {
                rows.append(composeRowFromValue("X",model.valueHeadingX.value))
            }
            if settings.settingLayoutShowHeadingY.value {
                rows.append(composeRowFromValue("Y",model.valueHeadingY.value))
            }
            if settings.settingLayoutShowHeadingZ.value {
                rows.append(composeRowFromValue("Z",model.valueHeadingZ.value))
            }

            data.sections.append(Section(title:"HEADING", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [Row] = []
            
            if settings.settingLayoutShowBeaconUUID.value {
                rows.append(composeRowFromValue("UUID",model.valueBeaconUUID.value))
            }
            if settings.settingLayoutShowBeaconMajor.value {
                rows.append(composeRowFromValue("MAJOR",model.valueBeaconMajor.value))
            }
            if settings.settingLayoutShowBeaconMinor.value {
                rows.append(composeRowFromValue("MINOR",model.valueBeaconMinor.value))
            }
            if settings.settingLayoutShowBeaconId.value {
                rows.append(composeRowFromValue("IDENTIFIER",model.valueBeaconIdentifier.value))
            }

            data.sections.append(Section(title:"BEACON", rows: rows))
        }

        self.data.value = data
    }
}
