//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            
            //Configured for iPhone 6s Plus with Retina HD 5.5 (1242 x 2208 pixels)
            //3x scaling from point to pixel, 401 ppi
            
            let pixelDistance = distance * 3
            let inchDistance = pixelDistance / 401
            let mmDistance = inchDistance * 25.4
            let roundedDistance = round(mmDistance * 100) / 100
            
            distanceLabel.text = "\(roundedDistance) mm"
        }
    }
}

