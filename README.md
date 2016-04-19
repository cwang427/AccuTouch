# AccuTouch

## Overview

**AccuTouch** is a data collection and visualization app designed for both surgeons and surgical devices – particularly those involved in minimally invasive surgery. When used in a simulated surgical environment, AccuTouch can give invaluable feedback on device stability and point-to-point accuracy.

## How to Use AccuTouch

### Setup

![Compatible Test Device](/images/TestModel.JPG)

AccuTouch is meant to be used with an external device. Shown above is a testing model of laparoscopic forceps – a device that is used in minimally invasive surgery. Compatible testing models must have a tip that is responsive with the iDevice's capacitive touch screen (I happened to have a pen with a capacitive tip, so I used that). Wire should be run from the tip to the handles and should contact the user's hand throughout testing to ensure the screen responds to all touches.

![Emory Laparoscopy Simulation Lab](/images/SimulatedSurgery.jpg)

Pictured above is Emory University Hospital's Laparoscopy Simulation Lab. The device running AccuTouch should be placed inside the surgical environment so that the user can only view it through the monitor displaying a feed from the laparoscope (camera facing inside).

### Interacting with the App

![Main Screen](/images/SimulatorSS.png)

AccuTouch displays a blue target dot on the screen. The user tries to touch and hold on the dot as close to its center as possible using the testing device (e.g. forceps). Dot diameter can be configured in Settings according to the diameter of the capacitive tip. AccuTouch will automatically begin recording data upon the first touch, and it will automatically terminate the set once the set size has been reached (default 10, also configured in Settings).

A set may be terminated at any time by pressing Stop, Settings, or Results.

The "Test Type" setting determines whether or not the user is testing for accuracy or precision. Accuracy tests will move the target to a random location on the screen after each touch, while precision tests keep the target in the center of the screen. Data collection is the same, but the Test Type is indicated in Results.

Once data has been collected, it can be transferred to a computer for further processing and statistical analysis (.csv export feature pending).

## Why is this Important?

![Front Rendering](/images/FrontRender.JPG)

![Perspective Rendering](/images/PerspectiveRender.JPG)

On one end of the spectrum, surgical device designers and manufacturers need methods to determine whether or not their models are suitable for the operating room. AccuTouch helps to bridge this gap between conceptual design and final product. Different design elements may be modified then tested using AccuTouch. The app simplifies data collection to allow the evaluator to quantitatively verify the device's effectiveness.

On the other end are surgeons and surgical residents who need to maintain a high degree of consistency and familiarity with their tools. AccuTouch serves as a practice tool for medical practitioners so they can achieve a higher level of confidence in their accuracy and precision.

## Future Directions

By using the CoreMotion framework, AccuTouch will be able to record deviceMotion (integrated accelerometer and gyroscope data) and display this data in graphs. This level of data visualization will indicate tremors involved during the procedure and provide insight into device stability.

The next version of AccuTouch is scheduled to include the option to export data to .csv format, which can easily be imported into Microsoft Excel for more rigorous data processing.