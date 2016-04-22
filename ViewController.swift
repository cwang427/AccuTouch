//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit
import AudioToolbox
import RealmSwift

var numReadings: Int = 0
var diameter: Double = 5.08
var setSize: Int = 10
var testType: String = "Accuracy"
var motionTracking: Bool = false

class ViewController: UIViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    
    //Outlets for view constants
    @IBOutlet weak var originWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var originHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var originCenterX: NSLayoutConstraint!
    @IBOutlet weak var originCenterY: NSLayoutConstraint!
    
    //Labels and view elements
    @IBOutlet weak var readingStateLabel: UILabel!
    @IBOutlet weak var numReadingsLabel: UILabel!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var resultsButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var hudBar: UIToolbar!
    
    //Reading state variables
    var isReading: Bool = false
    
    //Screen settings
    var pixelDensity: Double = 0
    let screenScale: Double = Double(UIScreen.mainScreen().scale)
    
    //Randomization bounds
    var bottomBound: Int = 0
    var topBound: Int = 0
    var leftBound: Int = 0
    var rightBound: Int = 0
    
    //Timing
    var timeStartDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numReadings = 0
        
        readingStateLabel.text = "Not Recording"
        readingStateLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 115/255, alpha: 1)
        
        //Load default values
        if let diameterString = defaults.valueForKey("Diameter Field"), diameterSwitch = defaults.objectForKey("Diameter Switch") {
            let diameterValue = Double(diameterString as! String)!
            let units = diameterSwitch as! Bool ? "mm" : "in"
            var mmDiameter = diameterValue
            if (units == "in") {
                mmDiameter = diameterValue * 25.4
            }
            diameter = mmDiameter
        } else {
            defaults.setValue("5.08", forKey: "Diameter Field")
            defaults.setBool(true, forKey: "Diameter Switch")
        }
        if let numValues = defaults.stringForKey("Dataset Field") {
            setSize = Int(numValues)!
        } else {
            defaults.setValue("10", forKey: "Dataset Field")
        }
        if let typeSwitch = defaults.objectForKey("Test Type Switch") {
            let storedType = typeSwitch as! Bool ? "Accuracy" : "Precision"
            testType = storedType
        } else {
            defaults.setValue(true, forKey: "Test Type Switch")
        }
        if let motionSwitch = defaults.objectForKey("Motion Tracking Switch") {
            motionTracking = motionSwitch as! Bool
        } else {
            defaults.setValue(false, forKey: "Motion Tracking Switch")
        }
        
        //Set up notification observer to save data before app becomes inactive
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        let appDelegate = UIApplication.sharedApplication().delegate
        center.addObserverForName("Application Resign Active", object: appDelegate, queue: queue) { notification in
            self.endReading()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //Set pixel density for different devices
        let viewHeight = self.view.frame.height
        if (viewHeight == 480 || viewHeight == 568 || viewHeight == 667) {
            pixelDensity = 326
        } else if (viewHeight == 736) {
            pixelDensity = 401
        } else {
            let alert = UIAlertController(title: "Configuration Error", message: "Device not found in calculation configuration", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        }
        
        //Make origin point a circle whose profile matches forceps tip (0.2 inch = 5.08 mm diameter)
        let pixelSides = (diameter/25.4) * pixelDensity
        let pointSides = pixelSides / screenScale
        originView.frame.size.height = CGFloat(pointSides)
        originView.frame.size.width = CGFloat(pointSides)
        originWidthConstraint.constant = CGFloat(pointSides)
        originHeightConstraint.constant = CGFloat(pointSides)
        originView.layer.cornerRadius = originView.frame.size.width / 2
        originView.clipsToBounds = true
        
        //Set top boundary for randomization
        let topOffset = Int(ceil(hudBar.center.y + hudBar.frame.height))
        topBound = topOffset + Int(ceil(originHeightConstraint.constant))
        
        //Set bottom boundary for randomization
        let bottomOffset = Int(floor(toolbar.center.y - toolbar.frame.height))
        bottomBound = bottomOffset - Int(ceil(originHeightConstraint.constant)) - 100
        
        //Set side boundaries
        leftBound = Int(ceil(originWidthConstraint.constant)) + 10
        rightBound = Int(ceil(self.view.frame.width - originWidthConstraint.constant)) - 10
        
        if (testType == "Accuracy") {
            randomizePosition()
        } else {
            originCenterX.constant = 0
            originCenterY.constant = 0
        }
    }
    
    @IBAction func measurePointLong(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            
            //Start recording data and timer if not previously reading
            if (!isReading) {
                isReading = true
                readingStateLabel.text = "Recording"
                readingStateLabel.textColor = UIColor(colorLiteralRed: 88/255, green: 246/255, blue: 77/255, alpha: 1)
                timeStartDate = NSDate()
            }
            
            let touchPoint = sender.locationInView(self.view)
            
            let originPoint = originView.center
            
            let xDiff = Double(touchPoint.x - originPoint.x)
            let yDiff = Double(touchPoint.y - originPoint.y)
            let distance = sqrt((pow(xDiff,2) + pow(yDiff,2)))
            
            let pixelDistance = distance * screenScale
            let inchDistance = pixelDistance / pixelDensity
            let mmDistance = inchDistance * 25.4
            let roundedDistance = round(mmDistance * 1000) / 1000
            
            //Set up coordinate measurements in mm
            let xPixelDistance = xDiff * screenScale
            let xinchDistance = xPixelDistance / pixelDensity
            let mmXDistance = xinchDistance * 25.4
            let roundedXDistance = round(mmXDistance * 1000) / 1000
            
            let yPixelDistance = yDiff * screenScale
            let yinchDistance = yPixelDistance / pixelDensity
            let mmYDistance = yinchDistance * 25.4
            let roundedYDistance = round(mmYDistance * 1000) / 1000
            
            if (isReading) {
                
                //If app is reading, create new data point and add to Realm
                let newData = DataPoint()
                newData.distance = "\(roundedDistance)"
                newData.xCoordinate = "\(roundedXDistance)"
                newData.yCoordinate = "\(roundedYDistance)"
                do {
                    let realm = try Realm()
                    try realm.write() {
                        realm.add(newData)
                    }
                } catch {
                    let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data. You may have to delete and reinstall AccuTouch.", preferredStyle: .Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            if (testType == "Accuracy") {
                randomizePosition()
            }
            
            numReadings += 1
            if (numReadings == setSize) {
                endReading()
            }
            numReadingsLabel.text = "Count: \(numReadings)"
        }
    }
    
    //Terminate set and stop timer
    @IBAction func endReading() {
        isReading = false
        readingStateLabel.text = "Not Recording"
        readingStateLabel.textColor = UIColor(colorLiteralRed: 255/255, green: 169/255, blue: 115/255, alpha: 1)
        if (numReadings > 0) {
            let stop = NSDate()
            let stopTime = stop.timeIntervalSinceDate(timeStartDate)
            let duration = "\(Double(round(10 * stopTime) / 10)) seconds"
            let newDataSet = DataSet()
            newDataSet.time = duration
            newDataSet.numData = numReadings
            newDataSet.testType = testType
            do {
                let realm = try Realm()
                try realm.write() {
                    realm.add(newDataSet)
                }
            } catch {
                let alert = UIAlertController(title: "Error: Realm access", message: "Unable to access or modify Realm data. You may have to delete and reinstall AccuTouch.", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            numReadings = 0
            numReadingsLabel.text = "Count: \(numReadings)"
        }
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        numReadingsLabel.text = "Count: \(numReadings)"
    }
    
    func randomizePosition() {
        if (rightBound - leftBound > 0 && bottomBound - topBound > 0) {
            let xPosRandom = Int(arc4random_uniform(UInt32(rightBound - leftBound) + 1)) + leftBound
            let yPosRandom = Int(arc4random_uniform(UInt32(bottomBound - topBound) + 1)) + topBound
            
            let xPosOffset = xPosRandom - Int(self.view.center.x)
            let yPosOffset = yPosRandom - Int(self.view.center.y)
            
            originCenterX.constant = CGFloat(xPosOffset)
            originCenterY.constant = CGFloat(yPosOffset)
        } else {
            let alert = UIAlertController(title: "Error: Out of Bounds", message: "Diameter setting is too large", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { void in
                self.performSegueWithIdentifier("OpenSettings", sender: self)
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

