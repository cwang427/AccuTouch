//
//  ResultsTableViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = mainInstance.measurementList.count
        return count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultsTableViewCell
        
        let row = indexPath.row
        let measurement = mainInstance.measurementList[row]
        cell.measurementLabel.text = measurement
        
        let coordinate = mainInstance.coordinateList[row]
        cell.coordinateLabel.text = coordinate
        
        //Start of each set has green background; end has red
        if (row % 10 == 0) {
            cell.backgroundColor = UIColor.greenColor()
        } else if (row % 9 == 0) {
            cell.backgroundColor = UIColor.redColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    @IBAction func clearData(sender: UIBarButtonItem) {
        mainInstance.coordinateList = []
        mainInstance.measurementList = []
        self.tableView.reloadData()
        numReadings = 0
    }
}