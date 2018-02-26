//
//  RoutesKindTableVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 9..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit

class RoutesKindTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
   
    
    var routeTimeData:[String] = UserDefaults.standard.object(forKey: "routeTime") as? [String] ?? [String]()
    var routeStationData: [Any] = UserDefaults.standard.object(forKey: "routeStation") as? [Any] ?? [Any]()
    var routeStationTimeData: [Any] = UserDefaults.standard.object(forKey: "routeStationTime") as? [Any] ?? [Any]()
    
    @IBOutlet weak var routeKindTable: UITableView!
    
     @IBOutlet weak var choiceRoute: UILabel!
    
    var sections = [Section]()
    
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeKindTable.delegate = self
        routeKindTable.dataSource = self
        print(routeStationData)
        print(routeStationTimeData)
        // Do any additional setup after loading the view.
        for route in routeTimeData{
            sections.append(Section(routeTime: "경로 #\(i+1)       \(route) 소요", station: routeStationData[i] as! [String], stationTime: routeStationTimeData[i] as! [String], expanded:false))
            i = i+1
        }
        print("-----------------\(sections)")
        self.routeKindTable.separatorColor = UIColor.clear
        
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)!
        registerForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func preferredContentSizeCategoryDidChange(notification: NSNotification!) {
        routeKindTable.reloadData()
        routeKindTable.reloadSectionIndexTitles()
        self.viewDidLoad()
    }
    
    private func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: Selector(("preferredContentSizeCategoryDidChange:")), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].station.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded){
            return 44
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hearder = ExpandableHeaderView()
        hearder.customInit(title: sections[section].routeTime, section: section, delegate: self)
        return hearder
    }
    var w = 0
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "routeTimeCell", for: indexPath)
        Cell.textLabel?.text = sections[indexPath.section].station[indexPath.row]
//        Cell.detailTextLabel?.text = sections[indexPath.section].stationTime[indexPath.row]
        Cell.detailTextLabel?.text = ""
//        let testtt = routeStationTimeData[indexPath.section]
//        var rr = testtt[indexPath.row]
//        print(testtt)
//        print(routeStationTimeData[indexPath.section])
//        print(indexPath.section)
//        Cell.detailTextLabel?.text = routeStationTimeData[indexPath.section]
        
        return Cell
    }
    

    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return "경로 #"+"\(section+1)"
//    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded

        choiceRoute.text = "경로 \(section+1) 선택됨"
        
        UserDefaults.standard.set(section, forKey: "polylineNumber")
        
        routeKindTable.beginUpdates()
        for i in 0 ..< sections[section].station.count{
            routeKindTable.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        routeKindTable.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RouteSave"{
            let testtt = segue.destination as? NaviCenter
//            testtt?.ShowDirenction(AnyIndex.self)
            testtt?.Direction()
        }
    }
    
    
}
