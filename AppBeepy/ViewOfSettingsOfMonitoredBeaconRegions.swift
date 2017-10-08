//
//  ViewOfSettingsOfMonitoredBeaconRegions.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class ViewOfSettingsOfMonitoredBeaconRegions : GenericControllerOfSettings
{
    
    
    
    private var settings : Settings {
        return AppDelegate.settings
    }
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.separatorStyle    = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        super.title = "Monitored Beacons"
        
        self.synchronizeWithSettings()
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    override func reload() {
        settings.synchronize()
        
        super.reload()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func createSections() -> [Section]
    {        
        return [
            
            Section(header  : "LAYOUT",
                cells   : [
                    
                    createCellForUISwitch(settings.settingLayoutShowLocation, title: "Location"),
                    createCellForUISwitch(settings.settingLayoutShowHeading, title: "Heading"),
                    createCellForUISwitch(settings.settingLayoutShowBeacon, title: "Beacon"),
                    createCellForUISwitch(settings.settingLayoutShowBeaconsRanged, title: "Ranged Beacons"),
                    createCellForUISwitch(settings.settingLayoutShowRegionsMonitored, title: "Monitored Regions"),
                    createCellForUISwitch(settings.settingLayoutShowRegionsRanged, title: "Ranged Regions"),

                ]),
            
        ]
    }
    
    
    
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt:indexPath)
        
        //        cell.selectedBackgroundView = UIView.create(withBackgroundColor:AppDelegate.Settings.settingColorBackground.value)
        
        return cell
    }
    
    override func viewWillDisappear             (_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear                (_ animated: Bool)
    {
        tableView.backgroundColor   = settings.settingColorBackgroundSettings.value

        colorForHeaderText          = .gray
        colorForFooterText          = colorForHeaderText
        
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    internal func synchronizeWithSettings() {
        self.fontForLabelText       = AppDelegate.viewOfSettings.fontForFieldText
        self.fontForFieldText       = AppDelegate.viewOfSettings.fontForFieldText
        self.fontForFooterText      = AppDelegate.viewOfSettings.fontForFooterText
        self.fontForHeaderText      = AppDelegate.viewOfSettings.fontForHeaderText
    }
    
}
