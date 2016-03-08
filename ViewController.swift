//
//  ViewController.swift
//  AccuTouch
//
//  Created by Cassidy Wang on 3/7/16.
//  Copyright © 2016 Cassidy Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
            print("touched: \(touchPoint)")
            
            let originPoint = self.view.center
            print("origin: \(originPoint)")
            
            let xDiff = (originPoint.x - touchPoint.x)
            let yDiff = (originPoint.y - touchPoint.y)
            let distance = sqrt((pow(xDiff,2) + pow(yDiff,2)))
            print("distance: \(distance)")
        }
    }
}

