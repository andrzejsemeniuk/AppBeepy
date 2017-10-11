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

    
    internal var settings   : Settings {
        return AppDelegate.settings
    }

    
    weak var viewModel      : ViewModel!
    
    
    var table               : UITableView!
    
    
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
        
        if true {
            let buttonForSettings = UIBarButtonItem.init(title: "Settings", style:.plain ,target: self, action: #selector(ViewOfDashboard.tapOnButtonForSettings(_:)))
            //        let buttonForSettings = UIBarButtonItem.init(title: "\u{2699}", style:.plain ,target: self, action: #selector(ControllerOfDashboard.tapOnButtonForSettings(_:)))
            //        let buttonForSettings = UIBarButtonItem.init(barButtonSystemItem: .compose , target: self, action: #selector(ControllerOfDashboard.tapOnButtonForSettings(_:)))
            
            self.navigationItem.rightBarButtonItem = buttonForSettings
        }
        
        self.synchronizeWithSettings()
        
        self.viewModel?.dirty.listener = { [weak self] value in
            if let value = value, value {
                self?.table?.reloadData()
                self?.view.setNeedsLayout()
            }
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
        return viewModel?.data.sections[safe:section]?.title
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
        return viewModel?.data.sections.count ?? 0
    }
    
    func tableView                     (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.data.sections[safe:section]?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = UITableViewCell()
        
        result.contentView.backgroundColor = .clear
        
        result.backgroundColor = .clear
        result.separatorInset = .zero
        result.layoutMargins = .zero
        
        if let row = viewModel?.data.sections[safe:indexPath.section]?.rows[safe:indexPath.row] {
        
            let value = UILabel()
            result.accessoryView = value
            
            result.textLabel?.attributedText = row.title.uppercased() | UIColor.white
            value.attributedText = row.value | UIColor.white
            
            value.sizeToFit()
        }

        return result
    }
    
}


