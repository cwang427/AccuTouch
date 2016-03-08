//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    @IBOutlet weak var readingStateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var isReading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingStateLabel.text = "Not Reading"
        readingStateLabel.textColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func measurePointLong(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Began) {
            let touchPoint = sender.locationInView(self.view)
            
            let originPoint = self.view.center
            
            let xDiff = Double(touchPoint.x - originPoint.x)
            let yDiff = Double(touchPoint.y - originPoint.y)
            let distance = sqrt((pow(xDiff,2) + pow(yDiff,2)))
            
            var pixelDensity: Double = 0
            let screenScale: Double = Double(UIScreen.mainScreen().scale)
            
            //Configure pixel density calculation for different devices
            let viewHeight = self.view.frame.height
            if (viewHeight == 480 || viewHeight == 568 || viewHeight == 667) {
                pixelDensity = 326
            } else if (self.view.frame.height == 736) {
                pixelDensity = 401
            } else {
                let alert = UIAlertController(title: "Configuration Error", message: "Device not found in calculation configuration", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            }
            
            let pixelDistance = distance * screenScale
            let inchDistance = pixelDistance / pixelDensity
            let mmDistance = inchDistance * 25.4
            let roundedDistance = round(mmDistance * 1000) / 1000
            
            distanceLabel.text = "\(roundedDistance) mm"
            
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
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    @IBAction func beginReading() {
        isReading = true
        readingStateLabel.text = "Reading"
        readingStateLabel.textColor = UIColor.greenColor()
        mainInstance.measurementList = []
    }
    
    @IBAction func endReading() {
        isReading = false
        readingStateLabel.text = "Not Reading"
        readingStateLabel.textColor = UIColor.redColor()
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
    }
}

