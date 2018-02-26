//
//  AlarmTableVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 20..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class AlarmTableVC: UITableViewController {
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet var alarmTable: UITableView!
    
    
    var identifier = String()
    var arrivalTime = String()
    var startName = String()
    var endName = String()
    var alarmTime = String()
    
    var arrivalTimeList = UserDefaults.standard.array(forKey: "arrivalTimeList") as? [String] ?? [String]()
    var identifierList = UserDefaults.standard.array(forKey: "identifierList") as? [String] ?? [String]()
    var weekLabelList = UserDefaults.standard.array(forKey: "weekLabelList") as? [String] ?? [String]()
    var startNameList = UserDefaults.standard.array(forKey: "startNameList") as? [String] ?? [String]()
    var endNameList = UserDefaults.standard.array(forKey: "endNameList") as? [String] ?? [String]()
    var alarmTimeList = UserDefaults.standard.array(forKey: "alarmTimeList") as? [String] ?? [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UNUserNotificationCenter.current().delegate = self // 앱이 실행된 상태에서도 출현
        UserDefaults.standard.removeObject(forKey: "nameLabel")
        UserDefaults.standard.removeObject(forKey: "routeTime")
        UserDefaults.standard.removeObject(forKey: "TransitMode")
        UserDefaults.standard.removeObject(forKey: "sinceTime")
        
        print("여기 \(identifier)")
        UserDefaults.standard.removeObject(forKey: "routeTimeValue")
        
        tableView.allowsSelectionDuringEditing = true
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
//        let backgroundImage = UIImage(named: "Default(1334,750).png")
//        tableView.backgroundView = UIImageView(image: UIImage(named: "Default(1334,750)"))
        
//        tableView.backgroundColor = UIColor.clear
        tableView.backgroundColor = .white
        
        let bgView = UIImageView(frame: tableView.bounds)
        bgView.image = UIImage(named: "noAlarmArrow3.png")
        bgView.contentMode = .scaleAspectFit
        
        let agView = UIImageView(frame: tableView.bounds)
        agView.image = UIImage(named: "")
        agView.contentMode = .scaleAspectFit
        
        if identifierList.isEmpty{
            tableView.backgroundView = bgView
        }else{
            tableView.backgroundView = agView
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if identifierList.count == 0 {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        
        return identifierList.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "alarmInfo", for: indexPath)
        if identifierList.isEmpty {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "alarmInfo")
        }
        
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        
        let alarm = (identifierList[indexPath.row])
        let time = "\(weekLabelList[indexPath.row])   \(arrivalTimeList[indexPath.row])"
        let amAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 20.0)]
        let str = NSMutableAttributedString(string: time , attributes: amAttr)
        let timeAttr: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue) : UIFont.systemFont(ofSize: 45.0)]
        
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        cell.textLabel?.attributedText = str
        cell.detailTextLabel?.text = alarm
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "출발지,목적지 확인",message: "출발: \(startNameList[indexPath.row]) \n 도착: \(endNameList[indexPath.row]) \n 소요시간: \(alarmTimeList[indexPath.row])", preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true,completion: nil)
        
//        \(startNameList[indexPath.row])\(endNameList[indexPath.row])
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        //dynamically append the edit button
        if identifierList.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
//            alarmModel.alarms.remove(at: index)
            center.removePendingNotificationRequests(withIdentifiers: ["\(identifierList[index])"])
            identifierList.remove(at: index)
            arrivalTimeList.remove(at: index)
            startNameList.remove(at: index)
            endNameList.remove(at: index)
            alarmTimeList.remove(at: index)
            
            
            UserDefaults.standard.set(identifierList, forKey: "identifierList")
            UserDefaults.standard.set(arrivalTimeList, forKey: "arrivalTimeList")
            UserDefaults.standard.set(startNameList, forKey: "startNameList")
            UserDefaults.standard.set(endNameList, forKey: "endNameList")
            UserDefaults.standard.set(alarmTimeList, forKey: "alarmTimeList")
            
//            let cells = tableView.visibleCells
//            for cell in cells {
//                let sw = cell.accessoryView as! UISwitch
//                //adjust saved index when row deleted
//                if sw.tag > index {
//                    sw.tag -= 1
//                }
//            }
            if identifierList.count == 0 {
                self.navigationItem.leftBarButtonItem = nil
                let agView = UIImageView(frame: tableView.bounds)
                agView.image = UIImage(named: "noAlarmArrow3.png")
                agView.contentMode = .scaleAspectFit
                self.tableView.backgroundView = agView
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
//    let center = UNUserNotificationCenter.current() // 객체 생성
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    var weekLabel = String()
    func addAlarm(){
        //        identifierList = UserDefaults.standard.array(forKey: "identifierList")
        //            as? [String] ?? [String]()
        
        let alarmTimeSecond = UserDefaults.standard.integer(forKey: "alarmTime")
        let weekday = UserDefaults.standard.integer(forKey: "weekday")
        
        switch weekday {
        case 1:
            weekLabel = "일"
        case 2:
            weekLabel = "월"
        case 3:
            weekLabel = "화"
        case 4:
            weekLabel = "수"
        case 5:
            weekLabel = "목"
        case 6:
            weekLabel = "금"
        case 7:
            weekLabel = "토"
            
        default:
            print("error")
        }
        
        weekLabelList.insert(weekLabel, at: 0)
        UserDefaults.standard.set(weekLabelList, forKey: "weekLabelList")
        
        identifierList.insert(identifier, at: 0)
        UserDefaults.standard.set(identifierList, forKey: "identifierList")
        
        arrivalTimeList.insert(arrivalTime, at: 0)
        UserDefaults.standard.set(arrivalTimeList, forKey: "arrivalTimeList")
        
        startNameList.insert(startName, at: 0)
        UserDefaults.standard.set(startNameList, forKey: "startNameList")
        
        endNameList.insert(endName, at: 0)
        UserDefaults.standard.set(endNameList, forKey: "endNameList")
        
        alarmTimeList.insert(alarmTime, at: 0)
        UserDefaults.standard.set(alarmTimeList, forKey: "alarmTimeList")
        
        
        let departureHour = alarmTimeSecond / 3600
        let departureMinute = alarmTimeSecond % 3600 / 60
        print("요게 진짜 \(departureHour)시 \(departureMinute)분 출발")
        
        center.requestAuthorization(options: options) { // 승인 요청
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        
        let endIndex = arrivalTime.index(arrivalTime.endIndex, offsetBy: -3)
        let truncated = arrivalTime.substring(to: endIndex)
        
        let content = UNMutableNotificationContent()
        content.title = "\(identifier)"
        content.body = "지금 출발하시면 \(truncated) 전에 도착할 수 있어요!"
        content.sound = UNNotificationSound(named: "bell.mp3")
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "rush-512", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: departureHour, minute: departureMinute, weekday: weekday), repeats: true)
        

        
        
        
        // make sure you give each request a unique identifier. (nextTriggerDate description)
        let request = UNNotificationRequest(identifier: "\(identifier)", content: content, trigger: trigger)
        
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
                return
            }
            print("완료!")
        }
    }
    
    @IBAction func saveAlarm(segue: UIStoryboardSegue){
        UserDefaults.standard.removeObject(forKey: "nameLabel")
        isEditing = false
    }
    
    
}

extension AlarmTableVC:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == identifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}
