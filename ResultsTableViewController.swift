//
//  ResultsTableViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit
import RealmSwift

class ResultsTableViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    var items = [[DataPoint]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        //Load data points from Realm
        do {
            let realm = try Realm()
            dataSets = realm.objects(DataSet)
            dataPoints = realm.objects(DataPoint)
        } catch {
            let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    //Create auto-updating container to hold DataPoint objects
    var dataPoints: Results<DataPoint>! {
        didSet {
            //When dataPoints update, update the table view
            self.tableView.reloadData()
        }
    }
    
    //Hold DataSet objects
    var dataSets: Results<DataSet>! {
        didSet {
            //When dataSets update, update the table view
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSets?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSet = dataSets[section] as DataSet
        return dataSet.numData
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultsTableViewCell
        
        updateItemArray()
        
        let section = indexPath.section
        let row = indexPath.row
        let dataPoint = items[section][row] as DataPoint
        cell.dataPoint = dataPoint
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var numDataString = ""
        if (dataSets[section].numData == 1) {
            numDataString = "\(dataSets[section].numData) point"
        } else {
            numDataString = "\(dataSets[section].numData) points"
        }
        return "Set \(section + 1)\r\n\(dataSets[section].testType)  –  \(numDataString)  –  \(dataSets[section].time)"
    }
    
    func updateItemArray() {
        var counter: Int = 0
        var numTransferred: Int = 0
        var tempArray: [DataPoint] = []
        while (counter < dataSets?.count) {
            tempArray = []
            for _ in 0..<dataSets[counter].numData {
                tempArray.append(dataPoints[numTransferred])
                numTransferred += 1
            }
            items.append(tempArray)
            counter += 1
        }
    }
    
    @IBAction func clearData(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Clearing data", message: "Are you sure you want to clear the stored data?", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { void in
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.deleteAll()
                }
                self.tableView.reloadData()
                self.doneButton.style = .Done
                numReadings = 0
            } catch {
                let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}