//
//  DateSaveVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 19..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit

class DateSaveVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var optionTable: UITableView!
    @IBOutlet weak var nameLabel: UITextField!
    
//    @IBAction func testButton(_ sender: Any) {
//        alarmTimeData.removeAll()
////        UserDefaults.standard.removeObject(forKey: "alarmTimeData")
//        getTime()
//        print(alarmTimeData)
//        optionTable.reloadData()
//    }
    
    let kindArray = ["기본값","넉넉하게","아주 넉넉하게"]
    let detailKindArray = ["경로를 검색한 시간을 그대로 사용합니다.","검색한 시간에서 조금더 여분의 시간을 갖습니다.","더욱더 많은 여분을 갖습니다."]
    
    var nuckNuck = 1
    
    var kind = "기본값"
    var detail = "경로를 검색한 시간을 그대로 사용합니다."
    @IBAction func timeSelected(_ sender: UIButton) {
        self.view.endEditing(true)
        let locationAlert = UIAlertController(title:"여분시간", message: "가는 시간의 정도를 선택합니다", preferredStyle: .actionSheet)
        
        let basic = UIAlertAction(title:"기본값",style: .default, handler: {(action:UIAlertAction) -> Void in
            self.kind = self.kindArray[0]
            self.detail = self.detailKindArray[0]
            self.nuckNuck = 1
            self.optionTable.reloadData()
            self.optionTable.reloadSectionIndexTitles()
            
        })
        
        let moreTime = UIAlertAction(title:"넉넉하게",style: .default, handler: {(action:UIAlertAction) -> Void in
            self.kind = self.kindArray[1]
            self.detail = self.detailKindArray[1]
            self.nuckNuck = 2
            self.optionTable.reloadData()
            self.optionTable.reloadSectionIndexTitles()
        })
        
        let mostTime = UIAlertAction(title:"아주 넉넉하게",style: .default, handler: {(action:UIAlertAction) -> Void in
            self.kind = self.kindArray[2]
            self.detail = self.detailKindArray[2]
            self.nuckNuck = 3
            self.optionTable.reloadData()
            self.optionTable.reloadSectionIndexTitles()
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        locationAlert.addAction(cancelAction)
        locationAlert.addAction(basic)
        locationAlert.addAction(moreTime)
        locationAlert.addAction(mostTime)

        self.present(locationAlert, animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Option", for: indexPath)
        
        
        
        cell.textLabel?.text = kind
        cell.detailTextLabel?.text = detail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var alarmTimeData = [AlarmTimeData]()
    
    
    func getTime(){
//        UserDefaults.standard.removeObject(forKey: "sinceTime")
        let calender = Calendar.current
        let hour = calender.component(.hour, from: alarmPicker.date)
        let minute = calender.component(.minute, from: alarmPicker.date)
        let weekday = calender.component(.weekday, from: alarmPicker.date)
        let second = 3600*hour + 60*minute
        
        

        
        UserDefaults.standard.set(second, forKey: "arrivalSecond")
        
        
//        var departureTime = second-durationTime
//
//        if departureTime < 0{
//            second = second+60*60*24
//            departureTime = second - durationTime
//        }
//
//        let departureHour = departureTime / 3600
//        let departureMinute = departureTime % 3600 / 60
        
//        print(departureHour)
//        print(departureMinute)
        
        
        let date1 = alarmPicker.date
        let sinceTime = Int(date1.timeIntervalSince1970)
        
        
        print("현재 요일은 \(weekday)")
        print("\(hour)시 \(minute)분 도착")
        print(second)
//        print(sinceTime)
        UserDefaults.standard.set(weekday, forKey: "weekday")
        UserDefaults.standard.set(sinceTime, forKey: "sinceTime")
        
//        alarmTimeData.append(AlarmTimeData(weekly: 1, hour: hour, minute: minute))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        optionTable.dataSource = self
        optionTable.delegate = self
        self.nameLabel.delegate = self
        print(nuckNuck)
        alarmPicker.backgroundColor = .white
        alarmPicker.setValue(UIColor.black, forKey:"textColor")
        

        self.optionTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.optionTable.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func nextView(_ sender: Any) {
        if nameLabel.text == ""{
            let alertController = UIAlertController(title: "선행사항",message: "제목을 입력하세요", preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelButton)
            self.present(alertController,animated: true,completion: nil)
        } else {
        performSegue(withIdentifier: "routeChoice", sender: AnyIndex.self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nameLabel = self.nameLabel.text
            if segue.identifier == "routeChoice"{
                getTime()
                let testvc = segue.destination as? NaviCenter
                testvc?.moveName = nameLabel!
                testvc?.nuckNuck = nuckNuck
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dateSaveVC(segue: UIStoryboardSegue){
        print("dateSaveVC")
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
