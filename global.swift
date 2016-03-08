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
    init(measurementList: [String]) {
        self.measurementList = measurementList
    }
}
var mainInstance = Main(measurementList: [])