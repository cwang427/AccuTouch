//
//  SettingsTableViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 4/18/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //Outlets
    @IBOutlet weak var diameterField: UITextField!
    @IBOutlet weak var datasetField: UITextField!
    @IBOutlet weak var diameterSwitch: UISwitch!
    @IBOutlet weak var testTypeSwitch: UISwitch!
    @IBOutlet weak var motionTrackingSwitch: UISwitch!
    @IBOutlet weak var restoreDefaultsCell: UITableViewCell!
    @IBOutlet weak var restoreDefaultsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        diameterField.text = defaults.valueForKey("Diameter Field") as? String
        datasetField.text = defaults.valueForKey("Dataset Field") as? String
        diameterSwitch.on = defaults.boolForKey("Diameter Switch")
        testTypeSwitch.on = defaults.boolForKey("Test Type Switch")
        motionTrackingSwitch.on = defaults.boolForKey("Motion Tracking Switch")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    @IBAction func restoreDefaults() {
        view.endEditing(true)
        diameterField.text = String(5.08)
        diameterSwitch.on = true
        datasetField.text = String(10)
        testTypeSwitch.on = true
        motionTrackingSwitch.on = false
        
        //Blink color upon reset
        let secondsDelay = 0.1
        let delay = secondsDelay * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        let bgColor = restoreDefaultsCell.backgroundColor!
        let textColor = restoreDefaultsText.textColor!
        restoreDefaultsCell.backgroundColor = textColor
        restoreDefaultsText.textColor = UIColor.whiteColor()
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.restoreDefaultsCell.backgroundColor = bgColor
            self.restoreDefaultsText.textColor = textColor
        })
    }

    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @IBAction func saveSettings(sender: UIBarButtonItem) {
        //Save settings if entered values are valid
        let typeValue = testTypeSwitch.on ? "Accuracy" : "Precision"
        testType = typeValue
        let trackingValue = motionTrackingSwitch.on
        motionTracking = trackingValue
        
        if let diameterValue = Double(diameterField.text!) {
            let units = diameterSwitch.on ? "mm" : "in"
            var mmDiameter = diameterValue
            if (units == "in") {
                mmDiameter = diameterValue * 25.4
            }
            diameter = mmDiameter
            
            if let setValue = Int(datasetField.text!) {
                setSize = setValue
                
                //If both entries are valid, save all values
                defaults.setValue(diameterField.text!, forKey: "Diameter Field")
                defaults.setBool(diameterSwitch.on, forKey: "Diameter Switch")
                defaults.setValue(datasetField.text!, forKey: "Dataset Field")
                defaults.setBool(testTypeSwitch.on, forKey: "Test Type Switch")
                defaults.setBool(motionTrackingSwitch.on, forKey: "Motion Tracking Switch")
                
                self.performSegueWithIdentifier("unwindToMain", sender: self)
            } else {
                let alert = UIAlertController(title: "Error: Set Size", message: "Please enter a valid integer for set size", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error: Target Diameter", message: "Please enter a valid number for diameter", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
