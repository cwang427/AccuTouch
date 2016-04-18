//
//  ResultsTableViewCell.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {

    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!
    
    var dataPoint: DataPoint? {
        didSet {
            if let dataPoint = dataPoint, measurementLabel = measurementLabel, coordinateLabel = coordinateLabel {
                measurementLabel.text = "Distance (mm): \(dataPoint.distance)"
                coordinateLabel.text = "Coordinate (mm): \(dataPoint.coordinate)"
            }
        }
    }

}
