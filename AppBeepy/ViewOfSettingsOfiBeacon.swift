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
import CoreLocation

class ViewOfSettingsOfiBeacon : UITableViewController
{
    
    
    
    var settings : Settings {
        return AppDelegate.settings
    }
    
    
    weak var viewModel : ViewModel!
    
    
    
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
        
        self.navigationController?.createAlertForInput(title: "Enter Identifier", message: "Identifier must be a unique name", value: "", ok: "OK", cancel: "Cancel") { [weak self] identifier in
            
            if self?.viewModel?.storedBeaconsGet().contains(where: { $0.identifier == identifier }) ?? false {
                self?.navigationController?.createAlertForAnswer(title: "Duplicate identifier", message: "This identifier \'\(identifier)\' already exists", ok: "OK") {
                    // do nothing
                }
                return
            }
            
            self?.navigationController?.createAlertForInput(title: "Enter a valid UUID", message: "You can paste a UUID value or use this newly generated value.", value: NSUUID().uuidString, ok: "OK", cancel: "Cancel") { uuid in
                
                let uuid = uuid.trimmed()
                
                guard let _ = UUID.init(uuidString: uuid) else {
                    self?.navigationController?.createAlertForAnswer(title: "Invalid UUID", message: "This entry \'\(uuid)\' is invalid", ok: "OK") {
                        // do nothing
                    }
                    return
                }
                
                self?.navigationController?.createAlertForInput(title: "Enter the Major value", message: "Major is an integer between 0 and 65535", value: "0", ok: "OK", cancel: "Cancel") { MAJOR in
                    
                    guard let major = CLBeaconMajorValue(MAJOR) else {
                        self?.navigationController?.createAlertForAnswer(title: "Invalid Major", message: "This entry \'\(MAJOR)\' is invalid", ok: "OK") {
                            // do nothing
                        }
                        return
                    }
                    
                    self?.navigationController?.createAlertForInput(title: "Enter the Minor value", message: "Minor is an integer between 0 and 65535", value: "0", ok: "OK", cancel: "Cancel") { MINOR in
                        
                        guard let minor = CLBeaconMinorValue(MINOR) else {
                            self?.navigationController?.createAlertForAnswer(title: "Invalid Minor", message: "This entry \'\(MINOR)\' is invalid", ok: "OK") {
                                // do nothing
                            }
                            return
                        }
                        
                        var beacon = StoredBeacon()
                        
                        beacon.UUID = uuid
                        beacon.major = major
                        beacon.minor = minor
                        beacon.identifier = identifier
                        
                        // TODO: REPLACE EXISTING WITH DUPLICATE?
                        self?.viewModel?.storedBeaconsAdd(beacon)
                        
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
    
    override func numberOfSections              (in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.storedBeaconsGet().count ?? 0
    }
    
    override func tableView                     (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let text = viewModel?.storedBeaconsGet()[safe:indexPath.row]?.identifier ?? "?"
        
        cell.textLabel?.attributedText = text | UIColor.lightGray
        
        return cell
    }
    
    
    
    override func viewWillAppear                (_ animated: Bool)
    {
        tableView.backgroundColor = settings.settingColorBackgroundSettings.value
        
        super.viewWillAppear(animated)
    }
    
    
}

extension ViewOfSettingsOfiBeacon {
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard
            editingStyle == .delete,
            let row = viewModel.storedBeaconsGet()[safe:indexPath.row] else {
                return
        }
        viewModel.storedBeaconsRemove(withIdentifier: row.identifier)
        self.tableView.reloadData()
    }
}

