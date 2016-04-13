//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit
import AudioToolbox

var numReadings: Int = 0

class ViewController: UIViewController {

    //Outlets for view constants
    @IBOutlet weak var originWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var originHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var originCenterX: NSLayoutConstraint!
    @IBOutlet weak var originCenterY: NSLayoutConstraint!
    
    //Labels
    @IBOutlet weak var readingStateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var numReadingsLabel: UILabel!
    
    //Reading state variables
    var isReading: Bool = false
    
    //Screen settings
    var pixelDensity: Double = 0
    let screenScale: Double = Double(UIScreen.mainScreen().scale)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingStateLabel.text = "Not Reading"
        readingStateLabel.textColor = UIColor.redColor()
        
        //Set pixel density for different devices
        let viewHeight = self.view.frame.height
        if (viewHeight == 480 || viewHeight == 568 || viewHeight == 667) {
            pixelDensity = 326
        } else if (self.view.frame.height == 736) {
            pixelDensity = 401
        } else {
            let alert = UIAlertController(title: "Configuration Error", message: "Device not found in calculation configuration", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        }
        
        //Make origin point a circle whose profile matches forceps tip (0.2 inch = 5.08 mm diameter)
        let pixelSides = 0.2 * pixelDensity
        let pointSides = pixelSides / screenScale
        originView.frame.size.height = CGFloat(pointSides)
        originView.frame.size.width = CGFloat(pointSides)
        originWidthConstraint.constant = CGFloat(pointSides)
        originHeightConstraint.constant = CGFloat(pointSides)
        originView.layer.cornerRadius = originView.frame.size.width / 2
        originView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func measurePointLong(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            let touchPoint = sender.locationInView(self.view)
            
            let originPoint = originView.center
            
            let xDiff = Double(touchPoint.x - originPoint.x)
            let yDiff = Double(touchPoint.y - originPoint.y)
            let distance = sqrt((pow(xDiff,2) + pow(yDiff,2)))
            
            let pixelDistance = distance * screenScale
            let inchDistance = pixelDistance / pixelDensity
            let mmDistance = inchDistance * 25.4
            let roundedDistance = round(mmDistance * 1000) / 1000
            
            distanceLabel.text = "\(roundedDistance) ± 2.54 mm"
            
            //Set up coordinate measurements in mm
            let xPixelDistance = xDiff * screenScale
            let xinchDistance = xPixelDistance / pixelDensity
            let mmXDistance = xinchDistance * 25.4
            let roundedXDistance = round(mmXDistance * 1000) / 1000
            
            let yPixelDistance = yDiff * screenScale
            let yinchDistance = yPixelDistance / pixelDensity
            let mmYDistance = yinchDistance * 25.4
            let roundedYDistance = round(mmYDistance * 1000) / 1000

            let coordinateString = "(\(roundedXDistance), \(roundedYDistance))"
            
            if (isReading) {
                mainInstance.measurementList += [distanceLabel.text!]
                mainInstance.coordinateList += [coordinateString]
                if (numReadings == 9) {
                    endReading()
                    numReadings = 0
                    numReadingsLabel.text = "\(numReadings)"
                } else {
                    numReadings += 1
                    numReadingsLabel.text = "\(numReadings)"
                }
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @IBAction func beginReading() {
        isReading = true
        readingStateLabel.text = "Reading"
        readingStateLabel.textColor = UIColor.greenColor()
    }
    
    @IBAction func endReading() {
        isReading = false
        readingStateLabel.text = "Not Reading"
        readingStateLabel.textColor = UIColor.redColor()
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
    }
}

