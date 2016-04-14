//
//  DataPoint.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 4/14/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import Foundation
import RealmSwift

class DataPoint: Object {
    
    dynamic var distance: String = ""
    dynamic var coordinate: String = ""
}
