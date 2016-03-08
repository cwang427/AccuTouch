//
//  global.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import Foundation

class Main {
    var measurementList: [String] = []
    var coordinateList: [String] = []
    init(measurementList: [String], coordinateList: [String]) {
        self.measurementList = measurementList
        self.coordinateList = coordinateList
    }
}
var mainInstance = Main(measurementList: [], coordinateList: [])