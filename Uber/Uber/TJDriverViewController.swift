//
//  TJDriverViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/21/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit
import MapKit

class TJDriverViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var customMap: MKMapView!
    @IBOutlet weak var sidebarItem: UIBarButtonItem!
    @IBOutlet weak var labelInfo: UILabel!

    @IBOutlet weak var tableview: UITableView!
    
    lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    lazy var geocoder: CLGeocoder = {
        let geocoder = CLGeocoder()
        return geocoder
    }()
    
    var addressArray:[AnyObject] = []
    var cityArray: [AnyObject] = []
    var driverAddress: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            
            sidebarItem.target = self.revealViewController()
            sidebarItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        manager.delegate = self
        manager.startUpdatingLocation()
        
        manager.requestAlwaysAuthorization()
        
        self.customMap.isRotateEnabled = false
        self.customMap.userTrackingMode = MKUserTrackingMode.follow
        
        let annotationsToRemove = self.customMap.annotations.filter { $0 !== self.customMap.userLocation }
        self.customMap.removeAnnotations( annotationsToRemove )
        
        self.tableview.backgroundColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(results), name: NSNotification.Name(rawValue: "CheckInfo"), object: nil)
    }
    
    
    func results(_ notification: Notification){
        self.labelInfo.text = "Please Drive to the pickup ASAP..."
    }
    

    /*
    @IBAction func ItemActionCheck(_ sender: AnyObject) {
        
        self.tableview.clearsContextBeforeDrawing = true
        let request = NSFetchRequest<RiderInformation>(entityName: "RiderInformation")
        let riderContext = CoreDataManager.shareInstance().setupContextWithModelName("RiderInfo")
        var infos: [AnyObject] = [AnyObject]()
        do{
            let dict = try riderContext.fetch(request)
            infos = dict
        }catch{
            print("error3")
        }
        
        for info in infos {
            let anno = MKPointAnnotation()
            let lat = info.value(forKey: "latitute") as! CLLocationDegrees
            let lon = info.value(forKey: "lontitute") as! CLLocationDegrees
            anno.coordinate = CLLocationCoordinate2DMake(lat, lon)
            self.customMap.addAnnotation(anno)
            
            let location = CLLocation(latitude: lat, longitude: lon)
            
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                let placemark = placemarks?.first
                anno.title = placemark?.name
                anno.subtitle = String(format: "%@, %@", (placemark?.locality)!, (placemark?.subAdministrativeArea)!)
                let dict1 = String(format: "%@", (placemark?.name)!)
                let dict2 = String(format: "%@, %@", (placemark!.locality)!, (placemark!.administrativeArea)!)
                self.addressArray.append(dict1 as AnyObject)
                self.cityArray.append(dict2 as AnyObject)
                self.tableview.reloadData()
            })
        }

    }
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "hello"{
            let obj: TJDetailViewController = segue.destination as! TJDetailViewController
            let indexPath = self.tableview.indexPathForSelectedRow
            obj.dataAddress = self.addressArray[((indexPath as NSIndexPath?)?.row)!] as? String
            obj.dataCity = self.cityArray[((indexPath as NSIndexPath?)?.row)!] as? String
            obj.driverAdd = self.driverAddress
        }
    }

  }


extension TJDriverViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKPointAnnotation.self) == false {
            return nil
        }
        let identifier = "anno"
        var annoView = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier))
        if annoView == nil {
            annoView = MKAnnotationView(annotation: nil, reuseIdentifier: identifier)
            annoView?.canShowCallout = true
        }
        annoView?.image = UIImage(named: "Rider")
        annoView?.annotation = annotation
        
        return annoView
        
    }
    
    //MARK: 999JSJODOAD
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.geocoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) in
            let placemark = placemarks?.first
            userLocation.title = placemark?.locality
            userLocation.subtitle = placemark?.name
        }
        
        self.driverAddress = userLocation.coordinate
        print(self.driverAddress) 

        let center = userLocation.location!.coordinate
        let span = MKCoordinateSpanMake(2.5, 2)
        let region = MKCoordinateRegionMake(center, span)
        self.customMap.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let spanLat = self.customMap.region.span.latitudeDelta
        let spanLon = self.customMap.region.span.longitudeDelta
        print("\(spanLat)-----\(spanLon)")
    }
}


extension TJDriverViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hello")
        cell?.textLabel?.text = self.addressArray[(indexPath as NSIndexPath).row] as? String
        cell?.detailTextLabel?.text = self.cityArray[(indexPath as NSIndexPath).row]  as? String
        cell?.textLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.textColor = UIColor.white

        cell!.backgroundColor = UIColor.black
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.blue
        cell!.selectedBackgroundView = bgColorView

        return cell!
    }
    
}


