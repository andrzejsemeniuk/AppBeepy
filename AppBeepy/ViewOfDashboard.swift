//
//  ViewController.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import UIKit
import ASToolkit
import CoreLocation

class ViewOfDashboard : UIViewController {

    internal var settings : Settings {
        return AppDelegate.settings
    }

    var model : ViewModelOfDashboard!
    
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table = UITableView()
        
//        self.table.layer.addSublayer(gradient)
//        self.table.contentInset.left = -16
//        self.table.separatorInset.left = 0
        self.table.backgroundColor = UIColor(hue:0.615)
        self.table.separatorColor = .white
        self.table.delegate = self
        self.table.dataSource = self
        
        self.view = table
        
        self.title = "Beepy"
        
        if false {
            let buttonForSettings = UIBarButtonItem.init(title: "Settings", style:.plain ,target: self, action: #selector(ViewOfDashboard.tapOnButtonForSettings(_:)))
            //        let buttonForSettings = UIBarButtonItem.init(title: "\u{2699}", style:.plain ,target: self, action: #selector(ControllerOfDashboard.tapOnButtonForSettings(_:)))
            //        let buttonForSettings = UIBarButtonItem.init(barButtonSystemItem: .compose , target: self, action: #selector(ControllerOfDashboard.tapOnButtonForSettings(_:)))
            
            self.navigationItem.rightBarButtonItem = buttonForSettings
        }
        
        self.synchronizeWithSettings()
        
        self.model?.data.listener = { [weak self] value in
            self?.table?.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear                (_ animated: Bool)
    {
        self.view.backgroundColor = settings.settingColorBackground.value

        super.viewWillAppear(animated)
    }

    @objc func tapOnButtonForSettings(_ item:UIBarButtonItem) {
        self.navigationController?.pushViewController(AppDelegate.viewOfSettings, animated: true)
    }

    internal func synchronizeWithSettings() {
        self.view.backgroundColor = settings.settingColorBackground.value
    }

}

extension ViewOfDashboard : UITableViewDelegate {
    
    
    
}

extension ViewOfDashboard : UITableViewDataSource {

    func tableView                     (_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model?.data.value?.sections[safe:section]?.title
    }

    func tableView                     (_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor.white
        }
    }
    
    func tableView                     (_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.textColor = UIColor.white
        }
    }

    func numberOfSections              (in tableView: UITableView) -> Int {
        return model?.data.value?.sections.count ?? 0
    }
    
    func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.value?.sections[safe:section]?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = UITableViewCell()
        
        result.contentView.backgroundColor = .clear
        
        result.backgroundColor = .clear
        result.separatorInset = .zero
        result.layoutMargins = .zero
        
        
//        switch (indexPath.section,indexPath.row) {
//        case (0,0):
//            result.textLabel?.attributedText = "LATITUDE" | UIColor.white
//            value.attributedText = "\(locationManager.location?.coordinate.latitude ?? 0)" | UIColor.white
//        case (0,1):
//            result.textLabel?.attributedText = "LONGITUDE" | UIColor.white
//            value.attributedText = "\(locationManager.location?.coordinate.longitude ?? 0)" | UIColor.white
//        case (0,2):
//            result.textLabel?.attributedText = "ALTITUDE" | UIColor.white
//            value.attributedText = "\(locationManager.location?.altitude ?? 0)" | UIColor.white
//        case (1,0):
//            result.textLabel?.attributedText = "MAGNETIC" | UIColor.white
//            value.attributedText = "\(locationManager.heading?.magneticHeading ?? 0)" | UIColor.white
//        default:
//
//            print("error")
//        }

        if let row = model.data.value?.sections[indexPath.section].rows[indexPath.row] {
        
            let value = UILabel()
            result.accessoryView = value
            
            result.textLabel?.attributedText = row.title.uppercased() | UIColor.white
            value.attributedText = row.value | UIColor.white
            
            value.sizeToFit()
        }

        return result
    }
    
}


