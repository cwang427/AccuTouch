//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var readingStateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    var isReading: Bool = false
//    var measurementList: [String] = []
    
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
            
            let xDiff = (originPoint.x - touchPoint.x)
            let yDiff = (originPoint.y - touchPoint.y)
            let distance = Double(sqrt((pow(xDiff,2) + pow(yDiff,2))))
            var roundedDistance: Double = 0
            
            //Configuration for iPhone 4s with Retina 3.5
            //2x scaling from point to pixel, 326 ppi
            
            if (self.view.frame.height == 480) {
                let pixelDistance = distance * 2
                let inchDistance = pixelDistance / 326
                let mmDistance = inchDistance * 25.4
                roundedDistance = round(mmDistance * 100) / 100
            }
            
            //Configuration for iPhone 6s Plus with Retina HD 5.5 (1242 x 2208 pixels)
            //3x scaling from point to pixel, 401 ppi
            
            else if (self.view.frame.height == 736) {
                let pixelDistance = distance * 3
                let inchDistance = pixelDistance / 401
                let mmDistance = inchDistance * 25.4
                roundedDistance = round(mmDistance * 100) / 100
            }
            
            distanceLabel.text = "\(roundedDistance) mm"
            if (isReading) {
                mainInstance.measurementList += [distanceLabel.text!]
            }
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

