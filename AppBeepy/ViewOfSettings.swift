//
//  ViewOfSettings.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

// TODO: MOVE RGB/HSB/CMYK VALUE DISPLAYES INTO OWN SECTION

// TODO: REMOVE SIZING PREFERENCES UNTIL NEXT VERSION
// TODO: PERHAPS HAVE A SINGLE SIZE SETTING FOR EVERYTHING
// TODO: STORE/LOAD COLOR PALETTE

class ViewOfSettings : GenericControllerOfSettings
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
        
        super.elementCornerSide     = 26
        
        super.elementCornerRadius   = super.elementCornerSide/2
        
        super.title = "Settings"
        
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
    
    
    
    
    
    
    
    
    
    
    open func createCellForUIColor1
        (_ setting      : GenericSetting<UIColor>,
         id             : String? = nil,
         title          : String,
         action         : (()->())? = nil) -> FunctionOnCell
    {
        let setupForPicker : ((GenericPickerOfColor)->())? = { [weak self, weak setting] picker in
            
            self?.settings.configure(picker: picker)
            
            let showLabels = picker.configuration.title.show
            
            let columns = 11
            let rows    = 11
            let deltaH  = CGFloat(1.0/Double(rows))
            let radius  = CGFloat(11)
            
            let colors : [UIColor] =
                UIColor.generateMatrixOfColors(columns    : columns,
                                               rowsOfGray : 0,
                                               rowsOfHues : rows).flatMap { $0 }
                    +
                    UIColor.generateMatrixOfColors(columns    : columns,
                                                   rowsOfGray : 1,
                                                   rowsOfHues : 0).flatMap { $0 }
            
            // palettes
            picker.configuration.title.show = false
            let palette0 = picker.addComponentStorageDots(title: "Palette", radius: radius, columns: columns, rows: rows + 1, colors: colors)
            
            palette0.backgroundColor = .clear
            
            // slider: hue
            
            picker.configuration.title.show = showLabels
            let hue = picker.addComponentSliderCustom(label                 : "<>" | UIColor.lightGray,
                                                      title                 : "HUE SHIFT",
                                                      color                 : .white) //UIColor(white:0,alpha:0.02))
            
            hue.leftButton  . setAttributedTitle(nil, for: .normal)
            hue.rightButton . setAttributedTitle(nil, for: .normal)
            hue.leftButton  . circle(for: .normal).fillColor = UIColor.clear.cgColor
            hue.rightButton . circle(for: .normal).fillColor = UIColor.clear.cgColor
            hue.rightView   . backgroundColor = .clear
            
            hue.action = { [weak palette0] value, dragging in
                if let storage = palette0 {
                    let shift = CGFloat(value.clampedTo01)
                    //                    var colors0 = colors
                    var colors1 = storage.colors
                    for i in stride(from:0,to:colors.count,by:1) {
                        var HSBA         = colors[i].HSBA
                        HSBA.hue        += deltaH * shift
                        HSBA.brightness  = colors1[i].HSBA.brightness
                        HSBA.alpha       = colors1[i].HSBA.alpha
                        colors1[i]       = UIColor.init(HSBA:HSBA)
                    }
                    storage.fill(colors:colors1)
                }
            }
            
            // slider: brightness
            
            let brightness = picker.addComponentSliderBrightness(title: "Brightness") { [weak palette0] slider in
                if let storage = palette0 {
                    var colors1 = storage.colors
                    for i in stride(from:0,to:colors.count,by:1) {
                        var HSBA = colors1[i].HSBA
                        HSBA.brightness = colors[i].HSBA.brightness * CGFloat(slider.slider.value)
                        colors1[i] = UIColor.init(HSBA:HSBA)
                    }
                    storage.fill(colors:colors1)
                }
            }
            
            brightness.slider.minimumValue = 0.2
            brightness.slider.maximumValue = 1.0
            
            // slider: alpha
            
            let alpha = picker.addComponentSliderAlpha(title: "Alpha") { [weak palette0] slider in
                if let storage = palette0 {
                    var colors1 = storage.colors
                    for i in stride(from:0,to:colors.count,by:1) {
                        var HSBA = colors1[i].HSBA
                        HSBA.alpha = colors[i].HSBA.alpha * CGFloat(slider.slider.value)
                        colors1[i] = UIColor.init(HSBA:HSBA)
                    }
                    storage.fill(colors:colors1)
                }
            }
            
            alpha.slider.minimumValue = 0
            alpha.slider.maximumValue = 1
            
            // when user taps on a storage dot (color or gray), the color is selected, and so pop the view controller
            palette0.handlerForTap = { [weak self] color in
                setting?.value = color
                self?.navigationController?.popViewController(animated: true)
            }
            
            picker.build()
            
            // HACK: CONFIGURE THE PALETTE AND SLIDER ONCE PICKER DISPLAYS
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    let color = picker.color
                    alpha.update(alpha,color,false)
                    brightness.update(brightness,color,false)
                    alpha.action(alpha.slider.value,false)
                    brightness.action(brightness.slider.value,false)
                }
            }
            
        }
        
        return super.createCellForUIColorWithGenericPickerOfColor(setting,
                                                                  id            : id,
                                                                  title         : title,
                                                                  setup         : nil,
                                                                  setupForPicker: setupForPicker,
                                                                  action        : action)
        
    }
    
    
    
    
    
    
    override func createSections() -> [Section]
    {
        return [
            
            Section(header  : "CONFIGURATIONS",
                    footer  : "Save current configuration, or load previously saved configuration",
                    cells   : [
                        
                        createCellForTapOnInput(title    : "Save As ...",
                                                message  : "Specify name for current configuration.",
                                                setup    : { [weak self] cell,indexpath in
                                                    cell.selectionStyle = .default
                                                    cell.accessoryType  = .none
                                                    if let detail = cell.detailTextLabel {
                                                        detail.text = self?.settings.configurationCurrent.value
                                                    }
                            }, value:{ [weak self] in
                                return ""
                        }) { [weak self] text in
                            
                            guard let `self` = self else { return }
                            
                            if 0 < text.length {
                                if self.settings.configuration(saveWithCustomName:text) {
                                    self.settings.configurationCurrent.value = text
                                    self.tableView.reloadData()
                                }
                            }
                        },
                        
                        createCellForTap(title: "Load", setup: { cell,indexpath in
                            cell.selectionStyle = .default
                            cell.accessoryType  = .disclosureIndicator
                        }) { [weak self] in
                            
                            guard let `self` = self else { return }
                            
                            let controller = GenericControllerOfList()
                            
                            controller.style = .grouped
                            
                            if 0 < self.settings.configurationArrayOfNamesCustom.count {
                                controller.sections += [
                                    GenericControllerOfList.Section(
                                        header  : "Custom Configurations",
                                        footer  : "A list of configurations created by you",
                                        items   : self.settings.configurationArrayOfNamesCustom
                                    )]
                            }
                            
                            controller.sections += [
                                GenericControllerOfList.Section(
                                    header  : "Predefined Configurations",
                                    footer  : "A list of standard configurations",
                                    items   : self.settings.configurationArrayOfNamesPredefined
                                )
                            ]
                            
                            controller.handlerForIsEditableAtIndexPath = { controller,path in
                                return path.section == 0
                            }
                            
                            controller.selected = self.settings.configurationCurrent.value
                            
                            controller.handlerForDidSelectRowAtIndexPath = { [weak self] controller, indexPath in
                                guard let `self` = self else { return }
                                if let selected = controller.item(at:indexPath) {
                                    self.settings.configuration(loadWithName:selected)
                                    AppDelegate.rootViewController.view.backgroundColor = self.settings.settingBackgroundColor.value
                                    controller.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                            controller.handlerForCommitEditingStyle = { [weak self] controller, commitEditingStyle, indexPath in
                                guard
                                    let `self` = self,
                                    commitEditingStyle == .delete
                                    else {
                                        return false
                                }
                                // TODO: TEST
                                if let selected = controller.item(at:indexPath), indexPath.section == 0 {
                                    return self.settings.configuration(removeCustomWithName:selected)
                                }
                                return false
                            }
                            
                            self.navigationController?.pushViewController(controller, animated:true)
                            
                        },
                        
                        ]),
            
            Section(header  : "LAYOUT",
                    footer  : "",
                    cells   : [
                        
                        createCellForTapOnQuestion(title: "Clear...", message: "Clear layout?") { [weak self] in
                            guard let `self` = self else { return }
                            self.settings.settingLayout.value = ""
                            for element in self.settings.collect(withPrefix: "settingComponent", withSuffix: "On") {
                                if let setting = element.object as? GenericSetting<Bool> {
                                    setting.value = false
                                }
                            }
                        },
                        
                        createCellForTap(title: "Configure", setup:{ cell,index in
                            cell.accessoryType  = .disclosureIndicator
                        }) { [weak self] in
                            self?.navigationController?.pushViewController(AppDelegate.controllerOfSettingsOfLayout, animated: true)
                        },
                        
                        createCellForUISwitch(settings.settingLayoutKeepDisplayOnTop, title: "Pin Display component to top"),
                        
                        createCellForTapOnRevolvingChoices(settings.settingComponentDisplaySize, title: "Display Size", choices: ["S","M","L"]),
                        
                        createCellForTapOnRevolvingChoices(settings.settingLayoutMargin, title: "Margin", choices: ["-","S","M","L","XL"]),
                        
                        createCellForTapOnRevolvingChoices(settings.settingLayoutStripesAlpha, title: "Stripes Alpha", choices: ["-","0.01","0.02","0.04","0.08"]),
                        
                        createCellForUISwitch(settings.settingComponentDisplayValueColorize, title: "Colorize values"),
                        
                        ]),
            
            Section(header  : "LABELS",
                    footer  : "",
                    cells   : [
                        
                        createCellForUISwitch(settings.settingLabelsOn, title: "Show"),
                        
                        createCellForUIColor1(settings.settingLabelsColorBackground, title: "Background Color"),
                        
                        createCellForUIColor1(settings.settingLabelsColorText, title: "Text Color"),
                        
                        createCellForUIFontName(settings.settingLabelsFontName, title: "Font"),
                        
                        createCellForUISwitch(settings.settingLabelsFontNameSameAsApp, title: "  Same as App"),
                        
                        createCellForTapOnRevolvingChoices(settings.settingLabelsSize,
                                                           title     : "Size",
                                                           choices   : ["XS","S","M","L","XL"]),
                        
                        ]),
            
            Section(header  : "OPERATIONS",
                    footer  : "",
                    cells   : [
                        
                        createCellForUIColor1(settings.settingOperationsButtonColorBackgroundNormal, title: "Button background color"),
                        
                        createCellForUIColor1(settings.settingOperationsButtonColorForegroundNormal, title: "Button foreground color"),
                        
                        createCellForUIColor1(settings.settingOperationsButtonColorBackgroundSelected, title: "Button background color when selected"),
                        
                        createCellForUIColor1(settings.settingOperationsButtonColorForegroundSelected, title: "Button foreground color when selected"),
                        
                        ]),
            
            Section(header  : "APP",
                    footer  : "",
                    cells   : [
                        
                        createCellForUIColor1(settings.settingBackgroundColor, title: "Background Color") { [weak self] in
                            self?.settings.synchronize()
                        },
                        
                        createCellForUIFontName(settings.settingFontName, name: "Font", title: "Font") { [weak self] in
                            self?.settings.synchronize()
                        },
                        
                        createCellForTapOnQuestion(title: "Reset...", message: "Reset settings ?") { [weak self] in
                            self?.settings.reset(withPrefix: "setting")
                            self?.tableView?.reloadData()
                            AppDelegate.settings.configuration(loadWithName:"Default")
                        },
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
            tableView.backgroundColor   = AppDelegate.controllerOfDashboard.view?.backgroundColor
        }
        else {
            tableView.backgroundColor   = settings.settingBackgroundColor.value
        }
        
        tableView.backgroundColor   = settings.settingBackgroundColor.value
        
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
        
        let size = UIFont.labelFontSize
        
        let font = UIFont.init(name:settings.settingFontName.value, size:size) ?? UIFont.systemFont(ofSize: size)
        
        self.fontForLabelText   = font.withSize(size)
        self.fontForFieldText   = font.withSize(size)
        self.fontForFooterText  = font.withSize(size - 2)
        self.fontForHeaderText  = font.withSize(size - 2)
    }
    
}
