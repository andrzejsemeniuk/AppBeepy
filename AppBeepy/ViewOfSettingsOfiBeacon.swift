//
//  ViewOfSettingsOfiBeacon.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/4/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import UIKit
import ASToolkit

class ViewModelOfSettingsOfiBeacon : NSObject {
    
    var model : Model!
    
}

class ViewOfSettingsOfiBeacon : UITableViewController
{
    
    
    
    private var settings : Settings {
        return AppDelegate.settings
    }
    
    
    var viewModel : ViewModelOfSettingsOfiBeacon!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource        = self
        
        tableView.delegate          = self
        
        tableView.separatorStyle    = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        super.title = "iBeacons"
        
        let buttonForSettings = UIBarButtonItem.init(barButtonSystemItem:.add, target: self, action: #selector(ViewOfSettingsOfiBeacon.tapOnButtonForAdd(_:)))
        
        self.navigationItem.rightBarButtonItem = buttonForSettings
    }
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @objc func tapOnButtonForAdd(_ item:UIBarButtonItem) {
        if debug {
            print("beacons string: \(settings.settingStoredBeacons.value)")
            print(self.viewModel.model.storedBeaconsGet())
        }
        self.navigationController?.createAlertForInput(title: "Enter Identifier", message: "Identifier is a unique name", value: "", ok: "OK", cancel: "Cancel") { [weak self] identifier in
            
            if self?.viewModel?.model?.storedBeaconsGet().contains(where: { $0.identifier == identifier }) ?? false {
                self?.navigationController?.createAlertForAnswer(title: "Duplicate identifier", message: "This identifier \'\(identifier)\' already exists", ok: "OK") {
                    // do nothing
                }
            }
            else {
                self?.navigationController?.createAlertForInput(title: "Enter UUID", message: "UUID", value: "", ok: "OK", cancel: "Cancel") { uuid in
                    
                    self?.navigationController?.createAlertForInput(title: "Enter Major", message: "Major is an integer between 0 and 65535", value: "", ok: "OK", cancel: "Cancel") { major in
                        
                        let major = UInt16(major) ?? 0
                        
                        self?.navigationController?.createAlertForInput(title: "Enter Minor", message: "Major is an integer between 0 and 65535", value: "", ok: "OK", cancel: "Cancel") { minor in
                            
                            let minor = UInt16(minor) ?? 0
                            
                            var beacon = StoredBeacon()

                            beacon.UUID = uuid
                            beacon.major = major
                            beacon.minor = minor
                            beacon.identifier = identifier
                            
                            self?.viewModel?.model?.storedBeaconsAdd(beacon)
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.storedBeaconsGet().count ?? 0
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let text = viewModel?.model?.storedBeaconsGet()[safe:indexPath.row]?.identifier ?? "?"
        
        cell.textLabel?.attributedText = text | UIColor.lightGray
        
        return cell
    }
    
    override func viewWillAppear                (_ animated: Bool)
    {
        tableView.backgroundColor   = settings.settingColorBackgroundSettings.value
        
        super.viewWillAppear(animated)
    }
    
    
}

