//
//  AlarmDateCenter.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 19..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import Foundation

struct AlarmTimeData{
    var weekly : Int!
    var hour : Int!
    var minute: Int!
    
    init(weekly: Int, hour: Int, minute: Int){
        self.weekly = weekly
        self.hour = hour
        self.minute = minute
    }
}
