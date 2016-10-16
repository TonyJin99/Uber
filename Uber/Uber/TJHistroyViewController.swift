//
//  TJHistroyViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/24/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit
import MapKit

class TJHistroyViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var sidebarItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            
            sidebarItem.target = self.revealViewController()
            sidebarItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let geocoder = CLGeocoder()
        let manager = CLLocationManager()
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        manager.requestAlwaysAuthorization()

        let lat = 40.1234 
        let lon = -74.1234 
        let location = CLLocation(latitude: lat, longitude: lon)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            for _ in 0..<4{
                let placemark = placemarks?.first
                print(placemark?.name)
            }
            print("111")
            
            geocoder.geocodeAddressString("New York", completionHandler: { (placemarks, error) in
                print("333")
            })
            
        }
        


       
        
        

    }



}
