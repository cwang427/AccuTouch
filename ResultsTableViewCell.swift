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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var dataPoint: DataPoint? {
        didSet {
            if let dataPoint = dataPoint, measurementLabel = measurementLabel, coordinateLabel = coordinateLabel {
                measurementLabel.text = dataPoint.distance
                coordinateLabel.text = dataPoint.coordinate
            }
        }
    }

}
