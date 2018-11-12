//
//  ViewController.swift
//  Capstone
//
//  Created by Stuti Patel on 10/11/18.
//  Copyright © 2018 Stuti Patel. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var wavePicker: UISegmentedControl!
    @IBOutlet weak var phonePicker: UISegmentedControl!
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    var x = 0.0
    var y = 0.0
    var z = 0.0
    var gyroX = 0.0
    var gyroY = 0.0
    var gyroZ = 0.0
    var thetaX = 0.0
    var thetaY = 0.0
    var thetaZ = 0.0
    var altitude = 0.0
    
    lazy var altimeter = CMAltimeter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        if let g_data = motionManager.gyroData, let m_data = motionManager.magnetometerData {
            
            gyroX = g_data.rotationRate.x
            gyroY = g_data.rotationRate.y
            gyroZ = g_data.rotationRate.z
            thetaX = m_data.magneticField.x
            thetaY = m_data.magneticField.y
            thetaZ = m_data.magneticField.z
            
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (altitudeData:CMAltitudeData?, error:Error?) in
                
                self.altitude = Double(altitudeData!.relativeAltitude.floatValue)
            })
            var waveChoice = "sine"
            switch (wavePicker.selectedSegmentIndex) {
            case 0:
                waveChoice = "sine"
                break
            case 1:
                waveChoice = "square"
                break
            case 2:
                waveChoice = "sawtooth"
                break;
            case 3:
                waveChoice = "triangle"
                break
            default:
                waveChoice = "sine"
            }
            
            var phoneChoice = "0"
            switch(phonePicker.selectedSegmentIndex) {
            case 0:
                phoneChoice = "0"
                break
            case 1:
                phoneChoice = "1"
                break
            default:
                phoneChoice = "0"
                break
            }
            
            let parameters = ["phone": phoneChoice, "wave": waveChoice, "gx": String(gyroX), "gy": String(gyroY), "gz": String(gyroZ), "tx": String(thetaX), "ty": String(thetaY), "tz": String(thetaZ), "altitude": "\(altitude)"]
            //create the url with URL
            let url = URL(string: "http://5halfcap.ngrok.io/phone")!
            
            //create the session object
            let session = URLSession.shared
            
            //now create the URLRequest object using the url object
            var request = URLRequest(url: url)
            request.httpMethod = "POST" //set http method as POST
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            //create dataTask using the session object to send data to the server
            let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        // handle json...
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
            
        }
    }

    
}

