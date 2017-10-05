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

    var locationManager : CLLocationManager!
    
    weak var model : ViewModelOfDashboard?
    
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        self.table = UITableView()
        
//        self.table.layer.addSublayer(gradient)
//        self.table.contentInset.left = -16
//        self.table.separatorInset.left = 0
        self.table.backgroundColor = UIColor(hue:0.615)
        self.table.separatorColor = .white
        self.table.delegate = self
        self.table.dataSource = self
        
        self.view = table
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewOfDashboard : UITableViewDelegate {
    
    
    
}

extension ViewOfDashboard : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = UITableViewCell()
        result.contentView.backgroundColor = .clear
        result.backgroundColor = .clear
        result.separatorInset = .zero
        result.layoutMargins = .zero
        
        switch indexPath.row {
        case 0:
            result.textLabel?.attributedText = "LATITUDE: \(locationManager.location?.coordinate.latitude ?? 0)" | UIColor.white
        case 1:
            result.textLabel?.attributedText = "LONGITUDE: \(locationManager.location?.coordinate.longitude ?? 0)" | UIColor.white
        case 2:
            result.textLabel?.attributedText = "ALTITUDE: \(locationManager.location?.altitude ?? 0)" | UIColor.white
        case 3:
            result.textLabel?.attributedText = "HEADING/MAGNETIC: \(locationManager.heading?.magneticHeading ?? 0)" | UIColor.white
        default:
            
            print("error")
        }
        return result
    }
    
}

extension ViewOfDashboard : CLLocationManagerDelegate {
    
}
