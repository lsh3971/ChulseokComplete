//
//  ViewController.swift
//  LoadProject
//
//  Created by tigris on 2018. 1. 19..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UserDefaults.standard.removeObject(forKey: "routeTime")
        UserDefaults.standard.removeObject(forKey: "TransitMode")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

