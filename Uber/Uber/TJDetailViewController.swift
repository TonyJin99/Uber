//
//  TJDetailViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/25/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit
import MapKit


class TJDetailViewController: UIViewController{

    lazy var geocoder: CLGeocoder = {
        let geocoder = CLGeocoder()
        return geocoder
    }()
    
    var dataAddress: String?
    var dataCity: String?
    var driverAdd: CLLocationCoordinate2D?
    var address: String?

    var callingContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)

    @IBOutlet weak var label2: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label2.numberOfLines = 0
        self.label2.text = String(format: "%@, %@", dataAddress!, dataCity!)
        
        callingContext = CoreDataManager.shareInstance().setupContextWithModelName("CallingInfo")
        
        let latitute = driverAdd?.latitude
        let lontitute = driverAdd?.longitude
        let location = CLLocation(latitude: latitute!, longitude: lontitute!)
        
        self.geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if placemarks?.count == 0{
                return
            }
            let placemark = placemarks?.first
            let address = String(format: "%@, %@, %@", (placemark?.name)!, (placemark?.locality)!, (placemark?.administrativeArea)!)
            self.address = address
        }
        print("try rebase")
        print(self.address)
    }

    
    @IBAction func buttonActionAccept(_ sender: AnyObject) {
        
        let center = NotificationCenter.default
        center.post(name: Notification.Name(rawValue: "CheckInfo"), object: nil)
        
        let info = NSEntityDescription.insertNewObject(forEntityName: "CallingInformation", into: self.callingContext)
        let text = self.label2.text
        info.setValue(text, forKey: "address")
        
        do {
            try self.callingContext.save()
            print("accept sucess")
        } catch   {
            print("error2")
        }
    }
    
}
