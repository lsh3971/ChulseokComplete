//
//  NameAddVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 21..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit

class NameAddVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    let nameLabel = UserDefaults.standard.string(forKey: "nameLabel") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = nameLabel
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? DateSaveVC
        vc?.nameLabel.text = nameField.text
        UserDefaults.standard.set(nameField.text, forKey: "nameLabel")
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
