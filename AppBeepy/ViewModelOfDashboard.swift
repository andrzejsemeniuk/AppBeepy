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

            data.sections.append(Section(title:"LOCATION", rows: rows))
        }
        
        if settings.settingLayoutShowHeading.value {
            var rows : [Row] = []
            
            if settings.settingLayoutShowHeadingMagnetic.value {
                rows.append(composeRowFromValue("MAGNETIC",model.valueHeadingMagnetic.value))
            }
            
            data.sections.append(Section(title:"HEADING", rows: rows))
        }
        
        self.data.value = data
    }
}
