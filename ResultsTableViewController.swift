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

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        //Load data points from Realm
        do {
            let realm = try Realm()
            dataPoints = realm.objects(DataPoint)
        } catch {
            let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    //Create auto-updating container to hold DataPoint objects
    var dataPoints: Results<DataPoint>! {
        didSet {
            //When dataPoints update, update the table view
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPoints?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultsTableViewCell
        
        let row = indexPath.row
        let dataPoint = dataPoints[row] as DataPoint
        cell.dataPoint = dataPoint
        
        //Start of each set has green background; end has red
        if (row % 10 == 0) {
            cell.backgroundColor = UIColor.greenColor()
        } else if ((row + 1) % 10 == 0) {
            cell.backgroundColor = UIColor.redColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
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