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

class ViewOfSettingsLayout : GenericControllerOfSettings
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
                Weak(self.settings.settingComponentDisplayBackgroundOn),
                Weak(self.settings.settingComponentDisplayDotOn),
                Weak(self.settings.settingComponentDisplayFillOn),
                Weak(self.settings.settingComponentDisplaySplitVerticalOn),
                Weak(self.settings.settingComponentDisplaySplitHorizontalOn),
                Weak(self.settings.settingComponentDisplaySplitDiagonalOn),
            ]
            }()
        
        return [
            //            Section(header  : "LAYOUT",
            //                    footer  : "",
            //                    cells   : [
            
            //                        createCellForTapOnRevolvingChoices(settings.settingLayoutMargin,
            //                                                           title     : "Size",
            //                                                           choices   : ["XS","S","M","L","XL"]),
            
            //                        ]),
            
            Section(header  : "Switching determines display order"),
            
            Section(header  : "DISPLAYS",
                    //                    footer  : "Switching order determines display order",
                cells   : [
                    
                    createCellForUISwitch(settings.settingComponentDisplayBackgroundOn, title: "Background", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    createCellForUISwitch(settings.settingComponentDisplayDotOn, title: "Dot", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    createCellForUISwitch(settings.settingComponentDisplayFillOn, title: "Fill", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    createCellForUISwitch(settings.settingComponentDisplaySplitDiagonalOn, title: "Diagonal Split", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    createCellForUISwitch(settings.settingComponentDisplaySplitVerticalOn, title: "Vertical Split", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    createCellForUISwitch(settings.settingComponentDisplaySplitHorizontalOn, title: "Horizontal Split", exclusive:exclusiveDisplays) { [weak self] value in
                        self?.tableView?.reloadSections(IndexSet.init(integer:1), with: .automatic)
                    },
                    
                    ]),
            
            Section(header  : "VALUE",
                    //                    footer  : "Switching order determines display order",
                cells   : [
                    
                    createCellForUISwitch(settings.settingComponentDisplayValueAlphaOn, title: "Alpha"),
                    createCellForUISwitch(settings.settingComponentDisplayValueRGBAHexOn, title: "RGBA as Hexadecimal"),
                    createCellForUISwitch(settings.settingComponentDisplayValueRGBOn, title: "RGB"),
                    createCellForUISwitch(settings.settingComponentDisplayValueHSBOn, title: "HSB"),
                    createCellForUISwitch(settings.settingComponentDisplayValueCMYKOn, title: "CMYK"),
                    
                    ]),
            
            Section(header  : "SLIDERS",
                    //                    footer  : "Switching order determines display order",
                cells   : [
                    createCellForUISwitch(settings.settingComponentSliderAlphaOn,               title: "Alpha"),
                    createCellForUISwitch(settings.settingComponentSliderRedOn,                 title: "Red"),
                    createCellForUISwitch(settings.settingComponentSliderGreenOn,               title: "Green"),
                    createCellForUISwitch(settings.settingComponentSliderBlueOn,                title: "Blue"),
                    createCellForUISwitch(settings.settingComponentSliderHueOn,                 title: "Hue"),
                    createCellForUISwitch(settings.settingComponentSliderSaturationOn,          title: "Saturation"),
                    createCellForUISwitch(settings.settingComponentSliderBrightnessOn,          title: "Brightness"),
                    createCellForUISwitch(settings.settingComponentSliderCyanOn,                title: "Cyan"),
                    createCellForUISwitch(settings.settingComponentSliderMagentaOn,             title: "Magenta"),
                    createCellForUISwitch(settings.settingComponentSliderYellowOn,              title: "Yellow"),
                    createCellForUISwitch(settings.settingComponentSliderKeyOn,                 title: "Key/Black"),
                    ]),
            
            Section(header  : "COLOR STORAGE",
                    //                    footer  : "Switching order determines display order",
                cells   : [
                    createCellForUISwitch(settings.settingComponentStorageDotsOn,               title: "Dots"),
                    
                    //                        createCellForTapOnRevolvingChoices(settings.settingComponentStorageDotsSize,
                    //                                                           title     : "  size",
                    //                                                           choices   : ["S","M","L"]),
                    
                    createCellForTapOnRevolvingChoices(value     : { [weak self] in
                        return "\(self?.settings.settingComponentStorageDotsRows.value ?? 0)"
                        },
                                                       title     : "  Rows",
                                                       choices   : ["1","2","3","4","5","6"]) { [weak self] value in
                                                        if let number = Int(value) {
                                                            self?.settings.settingComponentStorageDotsRows.value = number
                                                        }
                    },
                    
                    createCellForUISwitch(settings.settingComponentStorageHistoryOn,                title: "History"),
                    
                    createCellForTapOnRevolvingChoices(value     : { [weak self] in
                        return "\(self?.settings.settingComponentStorageDragRows.value ?? 0)"
                        },
                                                       title     : "  Rows",
                                                       choices   : ["1","2","3","4","5","6"]) { [weak self] value in
                                                        if let number = Int(value) {
                                                            self?.settings.settingComponentStorageHistoryRows.value = number
                                                        }
                    },
                    
                    createCellForUISwitch(settings.settingComponentStorageDragOn,                   title: "Drag"),
                    
                    //                         TODO
                    //                        createCellForTapOnInput(title    : "Save Colors As ...",
                    //                                                message  : "Specify name for current palette of colors",
                    //                                                setup    : { [weak self] cell,indexpath in
                    //                                                    cell.selectionStyle = .default
                    //                                                    cell.accessoryType  = .none
                    //                                                    if let detail = cell.detailTextLabel {
                    //                                                        detail.text = self?.settings.configurationCurrent.value
                    //                                                    }
                    //                            }, value:{ [weak self] in
                    //                                return (self?.settings.configurationCurrent.value ?? "") + "+"
                    //                        }) { [weak self] text in
                    //
                    //                        },
                ]),
            
            Section(header  : "MISCELLANEOUS",
                    //                    footer  : "Switching order determines display order",
                cells   : [
                    createCellForUISwitch(settings.settingComponentOperationsOn,               title: "Operations")
                ]),
            
        ]
    }
    
    
    
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt:indexPath)
        
        //        cell.selectedBackgroundView = UIView.create(withBackgroundColor:AppDelegate.Settings.settingBackgroundColor.value)
        
        return cell
    }
    
    override func viewWillDisappear             (_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear                (_ animated: Bool)
    {
        if settings.settingComponentDisplayBackgroundOn.value {
            tableView.backgroundColor = AppDelegate.controllerOfDashboard.view?.backgroundColor
        }
        else {
            tableView.backgroundColor = settings.settingBackgroundColor.value
        }
        
        colorForHeaderText          = .gray
        colorForFooterText          = colorForHeaderText
        
        tableView.reloadData()
        
        super.viewWillAppear(animated)
    }
    
    internal func synchronizeWithSettings() {
        if settings.settingComponentDisplayBackgroundOn.value {
            self.view.backgroundColor = AppDelegate.controllerOfDashboard.view?.backgroundColor
        }
        else {
            self.view.backgroundColor = settings.settingBackgroundColor.value
        }
        
        self.fontForLabelText   = AppDelegate.controllerOfSettings.fontForFieldText
        self.fontForFieldText   = AppDelegate.controllerOfSettings.fontForFieldText
        self.fontForFooterText  = AppDelegate.controllerOfSettings.fontForFooterText
        self.fontForHeaderText  = AppDelegate.controllerOfSettings.fontForHeaderText
    }
    
}
