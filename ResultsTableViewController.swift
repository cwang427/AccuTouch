//
//  ResultsTableViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class ResultsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    var items = [[DataPoint]]()
    var maxRows: Int = 0
    
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
            let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data. You may have to delete and reinstall AccuTouch.", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
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
        if (dataSet.numData > maxRows) {
            maxRows = dataSet.numData
        }
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
        let maxCount = dataSets?.count
        var numTransferred: Int = 0
        var tempArray: [DataPoint] = []
        while (counter < maxCount) {
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
                self.maxRows = 0
            } catch {
                let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data. You may have to delete and reinstall AccuTouch.", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Enable export to .CSV
    @IBAction func exportCSV(sender: UIBarButtonItem) {
        let mailString: NSMutableString = generateString()
        
        //Convert to NSData
        let data = mailString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let emailController = generateEmailController(data)
        if (MFMailComposeViewController.canSendMail()) {
            self.presentViewController(emailController, animated: true, completion: nil)
        } else {
            let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Please check email configuration and try again.", preferredStyle: .Alert)
            sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
        }
    }
    
    func generateString() -> NSMutableString {
        let mailString = NSMutableString()
        var headers: String = ""
        var labels: String = ""
        var dataArray = [String](count: maxRows, repeatedValue: "")
        
        headers += ""
        labels += "Point"
        
        for row in 0..<maxRows {
            dataArray[row] += "\(row + 1)"
        }
        
        for section in 0..<numberOfSectionsInTableView(self.tableView) {
            
            //Set up CSV headers
            headers += ",Set #\(section + 1), , "
            labels += ",Distance (mm),x (mm),y (mm)"
            
            for row in 0..<maxRows {
                if row < items[section].count {
                    let dataPoint = items[section][row] as DataPoint
                    dataArray[row] += ",\(dataPoint.distance),\(dataPoint.xCoordinate),\(dataPoint.yCoordinate)"
                } else {
                    dataArray[row] += ", , , "
                }
            }
            if (section == numberOfSectionsInTableView(self.tableView) - 1) {
                for index in 0..<dataArray.count {
                    dataArray[index] += "\n"
                }
            }
        }
        headers += "\n"
        labels += "\n"
        
        mailString.appendString(headers)
        mailString.appendString(labels)
        for index in 0..<dataArray.count {
            mailString.appendString(dataArray[index])
        }
        mailString.appendString("\n\n")
        mailString.appendString("Error:, ± \(round(100 * diameter/2) / 100)")
        
        return mailString
    }
    
    func generateEmailController(data: NSData?) -> MFMailComposeViewController {
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setSubject("CSV Data")
        emailController.setMessageBody("", isHTML: false)
        
        //Attach .CSV
        if let content = data {
            emailController.addAttachmentData(content, mimeType: "text/csv", fileName: "AccuTouch Data")
            return emailController
        } else {
            emailController.setMessageBody("Error attaching data", isHTML: false)
            return emailController
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}