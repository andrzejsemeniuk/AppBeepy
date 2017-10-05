//
//  ViewOfSettingsLayout.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class ViewOfSettingsOfLayout : GenericControllerOfSettings
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
        
        super.title = "Settings/Layout"
        
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
        let exclusiveDisplays : [Weak<GenericSetting<Bool>>] = { [weak self] in
            guard let `self` = self else { return [] }
            return [
            ]
            }()
        
        let applyToSettings: (String,Bool)->() = { [weak self] prefix, value in
            for setting in self?.settings.collect(withPrefix:prefix) ?? [] {
                if let setting = setting.object as? GenericSetting<Bool> {
                    setting.value = true
                }
            }
        }
        
        return [
            
            Section(header  : "LOCATION",
                cells   : [
                    
//                    createCellForUISwitch(settings.settingLayoutShowLocation, title: "All") { [weak self] value in
//                        applyToSettings("settingLayoutShowLocation",value)
//                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
//                    },
                    
                    createCellForUISwitch(settings.settingLayoutShowLocationCoordinateLatitude, title: "Latitude"),
                    
//                    createCellForUISwitch(settings.settingComponentDisplayDotOn, title: "Dot", exclusive:exclusiveDisplays) { [weak self] value in
//                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
//                    },
                    
                    ]),
            
            Section(header  : "HEADING",
                cells   : [
                    
                    createCellForUISwitch(settings.settingLayoutShowHeadingMagnetic, title: "Magnetic")
                    
                    ]),
            
            Section(header  : "BEACON",
                cells   : [
                    createCellForUISwitch(settings.settingLayoutShowBeaconUUID, title: "UUID")
                    ]),
            
            Section(header  : "REGIONS",
                cells   : [
                    createCellForUISwitch(settings.settingLayoutShowRegionsMonitored, title: "Monitored")
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
