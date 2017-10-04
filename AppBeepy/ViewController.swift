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

class ViewController: UIViewController {

    var manager : CLLocationManager!
    
    weak var model : ViewModel?
    
    var table : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = CLLocationManager()
        self.manager.delegate = self
        
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

extension ViewController : UITableViewDelegate {
    
    
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = UITableViewCell()
        result.contentView.backgroundColor = .clear
        result.backgroundColor = .clear
        result.separatorInset = .zero
        result.layoutMargins = .zero
        // location/coordinate/latitude
        // location/coordinate/longitude
        // location/altitude
        // location/floor
        // location/accuracy/horizontal
        // location/accuracy/vertical
        // location/timestamp
        // location/speed
        // location/course
        // location/placemark
        // heading/magnetic
        // heading/true
        // heading/accuracy
        // heading/timestamp
        // heading/x
        // heading/y
        // heading/z
        // beacon/uuid
        // beacon/major
        // beacon/minor
        // beacon/id
        // regions: monitored/ranged-beacons
        // region/identifier
        // region/state
        // region/notify-on-entry/exit
        
        switch indexPath.row {
        case 0:
            result.textLabel?.attributedText = "LATITUDE: \(manager.location?.coordinate.latitude ?? 0)" | UIColor.white
        case 1:
            result.textLabel?.attributedText = "LONGITUDE: \(manager.location?.coordinate.longitude ?? 0)" | UIColor.white
        case 2:
            result.textLabel?.attributedText = "ALTITUDE: \(manager.location?.altitude ?? 0)" | UIColor.white
        case 3:
            result.textLabel?.attributedText = "HEADING/MAGNETIC: \(manager.heading?.magneticHeading ?? 0)" | UIColor.white
        default:
            
            print("error")
        }
        return result
    }
    
}

extension ViewController : CLLocationManagerDelegate {
    
}
