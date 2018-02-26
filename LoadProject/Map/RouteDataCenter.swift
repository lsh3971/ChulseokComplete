//
//  RouteDataCenter.swift
//  LoadProject
//
//  Created by tigris on 2018. 2. 9..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import Foundation

struct Section {
    var routeTime: String!
    var station: [String]!
    var stationTime: [String]!
    var expanded: Bool!
    
    
    init(routeTime: String, station: [String], stationTime: [String], expanded: Bool) {
        self.routeTime = routeTime
        self.station = station
        self.expanded = expanded
        self.stationTime = stationTime
    }
}
