//
//  TransitSideVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 5..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit

class TransitSideVC: UIViewController {
    
    @IBOutlet weak var transitMode: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var sideView: UIView!
    var Mode = 0
    
    
    @IBAction func Bus(_ sender: UIButton) {
        Mode = 1
        DataSave(Mode: Mode)
        transitMode.text = "버스"
    }
    
    @IBAction func Subway(_ sender: UIButton) {
        Mode = 2
        DataSave(Mode: Mode)
        transitMode.text = "지하철"
    }
    
    @IBAction func myCar(_ sender: UIButton) {
        Mode = 3
        DataSave(Mode: Mode)
        transitMode.text = "자가용"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 1
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        
        
      
        
        switch UserDefaults.standard.integer(forKey: "TransitMode") {
        case 1:
            transitMode.text = "버스"
        case 2:
            transitMode.text = "지하철"
        case 3:
            transitMode.text = "자가용"
        default:
            transitMode.text = "자가용"
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func DataSave(Mode : Int){
        let defaults = UserDefaults.standard
        defaults.set(Mode, forKey: "TransitMode")
        defaults.synchronize()
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
