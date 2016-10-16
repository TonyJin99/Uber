//
//  TJHomeViewController.swift
//  Uber
//
//  Created by Tony Jin on 6/14/16.
//  Copyright © 2016 Innovatis Tech. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TJHomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var textF_Pick: UITextField!
    @IBOutlet weak var textF_Destination: UITextField!
    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var labelCheck: UILabel!
    
    @IBOutlet weak var customMap: MKMapView!
    @IBOutlet weak var sidebarItem: UIBarButtonItem!
    @IBOutlet weak var slider: UISlider!
    
    lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        return manager
    }()
    
    lazy var geocoder: CLGeocoder = {
        let geocoder = CLGeocoder()
        return geocoder
    }()
    
    var riderContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.textF_Pick.resignFirstResponder()
        self.textF_Destination.resignFirstResponder()
        self.coverView.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.titleView = UIImageView(image: UIImage(named: "Rider"))
        riderContext = CoreDataManager.shareInstance().setupContextWithModelName("RiderInfo")
            
        if self.revealViewController() != nil {
            sidebarItem.target = self.revealViewController()
            sidebarItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = 220
        
        self.coverView.isHidden = true
        
        if textF_Pick.text!.isEmpty || textF_Destination.text!.isEmpty {
            self.buttonGo.isEnabled = false
        }
        
        textF_Pick.clearButtonMode = UITextFieldViewMode.always
        textF_Destination.clearButtonMode = UITextFieldViewMode.always
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        if (UIDevice.current.systemVersion as NSString).doubleValue > 8.0{
            manager.requestAlwaysAuthorization()
            print("after ios 8")
        }else{
            print("before ios 7")
        }
        
        self.customMap.isRotateEnabled = false
        self.customMap.userTrackingMode = MKUserTrackingMode.follow
        
        self.slider.setThumbImage(UIImage(named: "cars_slider"), for: UIControlState())
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
  
    func keyboardWillChangeFrame(_ notification: Notification){
        UIView.animate(withDuration: 2.0, animations: {
            self.coverView.isHidden = false
        }) 
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }

    
    func alertMeassage(_ title: String, message: String){
        
        let alertCont = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertCont.addAction(okButton)
        self.present(alertCont, animated: true, completion: nil)

    }
    
    
    @IBAction func itemActionCheck(_ sender: AnyObject) {
        
        let request = NSFetchRequest<CallingInformation>(entityName: "CallingInformation")
        let callingContext = CoreDataManager.shareInstance().setupContextWithModelName("CallingInfo")
        var infos: [AnyObject] = [AnyObject]()
        do{
            let dict = try callingContext.fetch(request)
            infos = dict
        }catch{
            print("error3")
        }
        
        if infos.isEmpty {
            self.alertMeassage("Information", message: "No driver accepted")
        }else{
            self.alertMeassage("Information", message: "The car is coming, please keep patience")
            self.labelCheck.text = "The car is coming......"
        }

    }

    
    @IBAction func buttonActionGo(_ sender: AnyObject) {
        
        let startStr = self.textF_Pick.text
        let endStr = self.textF_Destination.text
        
        self.geocoder.geocodeAddressString(startStr!) { (placemarks, error) in
            if placemarks?.count == 0{
                return
            }
            let startPlacemark = placemarks?.first
            self.geocoder.geocodeAddressString(endStr!, completionHandler: { (placemarks, error) in
                if placemarks?.count == 0{
                    return
                }
                let endPlacemark = placemarks?.first
                
                let latitute = ((endPlacemark?.location?.coordinate.latitude)! + (startPlacemark?.location?.coordinate.latitude)!) / 2
                let lontitute = ((endPlacemark?.location?.coordinate.longitude)! + (startPlacemark?.location?.coordinate.longitude)!) / 2
                let center = CLLocationCoordinate2DMake(latitute, lontitute)
                
                let lat = abs((endPlacemark?.location?.coordinate.latitude)! - (startPlacemark?.location?.coordinate.latitude)!) * 2
                let lon = abs((endPlacemark?.location?.coordinate.longitude)! - (startPlacemark?.location?.coordinate.longitude)!) * 2

                let span = MKCoordinateSpanMake(lat, lon)
                let region = MKCoordinateRegionMake(center, span)
                self.customMap.setCenter(center, animated: true)
                self.customMap.setRegion(region, animated: true)
 
                self.startDirectionsWithCLPlacemark(startPlacemark!, endCLPlacemark: endPlacemark!)
            })
        }
    }
    
    
    func startDirectionsWithCLPlacemark(_ startCLPlacemark: CLPlacemark, endCLPlacemark: CLPlacemark){
        
        let startPlacemark = MKPlacemark(placemark: startCLPlacemark)
        let startItem = MKMapItem(placemark: startPlacemark)
        
        let endPlacemark = MKPlacemark(placemark: endCLPlacemark)
        let endtItem = MKMapItem(placemark: endPlacemark)
        
        let request = MKDirectionsRequest()
        request.source = startItem
        request.destination = endtItem
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            let routes = response?.routes
            for route in routes!{
                self.customMap.add(route.polyline)
                let distance = "Distance: \(Int(route.distance/1600)) miles"
                let time = "Time: \(Int(route.expectedTravelTime/60)) minutes"
                self.alertMeassage("Information", message: "\(distance)\n\(time)")
            }
        }
    }

    
    @IBAction func buttonActionCallCar(_ sender: AnyObject) {

        let startStr = self.textF_Pick.text
        
        self.geocoder.geocodeAddressString(startStr!) { (placemarks, error) in
            if placemarks?.count == 0 || error != nil{
                return
            }
            
            let startPlacemark = placemarks?.first
            let random = Double(arc4random())/Double(UInt32.max)
            let latitute = (startPlacemark?.location?.coordinate.latitude)! + random - 0.5
            let lontitute = (startPlacemark?.location?.coordinate.longitude)! + random - 0.5
            
            let info = NSEntityDescription.insertNewObject(forEntityName: "RiderInfomation", into: self.riderContext)
            info.setValue(latitute, forKey: "latitute")
            info.setValue(lontitute, forKey: "lontitute")
            
            do {
                try self.riderContext.save()
                print("call sucess")
            } catch   {
                print("error2")
            }
            self.alertMeassage("Information", message: "Thanks for your calling, please waiting......")
        }
    }
    
    
    //MARK: --------------UITextFieldDelegate----------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let stringText = textField.text
       
        self.geocoder.geocodeAddressString(stringText!) { (placemarks, error) in
            if placemarks?.count == 0 || error != nil{
                return
            }
            let placemark = placemarks?.first
            let latitute = placemark?.location?.coordinate.latitude
            let lontitute = placemark?.location?.coordinate.longitude
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = CLLocationCoordinate2DMake(latitute!, lontitute!)
            
            self.customMap.addAnnotation(dropPin)
            self.customMap.setCenter(dropPin.coordinate, animated: true)
        }
        
        self.buttonGo.isEnabled = true
        print("22")
        textField.resignFirstResponder()
        self.coverView.isHidden = true

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    
    
    //MARK: ---------------CLLocationManagerDelegate------------
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.notDetermined{
            print("等待用户授权")
        }
        else if(status == CLAuthorizationStatus.authorizedAlways || status == CLAuthorizationStatus.authorizedWhenInUse){
            print("授权成功")
            manager.startUpdatingLocation()
        }else{
            print("授权失败")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        print("longtitude: \(location!.coordinate.longitude) ---- latitude: \(location!.coordinate.latitude)")
    }
 

    //MARK: ---------------MKMapViewDelegate-----------------
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        self.geocoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) in
            let placemark = placemarks?.first
            
            userLocation.title = placemark?.name
            userLocation.subtitle = placemark?.locality
            self.textF_Pick.text = String(format: "%@, %@, %@", (placemark?.name)!, (placemark?.locality)!, (placemark?.administrativeArea)!)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKind(of: MKPointAnnotation.self) == false {
            return nil
        }
        let identifier = "anno"
        var annoView = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier)) as? MKPinAnnotationView
        
        if annoView == nil {
            annoView = MKPinAnnotationView(annotation: nil, reuseIdentifier: identifier)
            annoView?.pinTintColor = UIColor.purple
            annoView?.animatesDrop = true
            annoView?.canShowCallout = true
            //annoView?.calloutOffset = CGPointMake(0, -20)
            annoView?.leftCalloutAccessoryView = UISwitch()
            annoView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.contactAdd)
        }
        
        annoView?.annotation = annotation
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let line = MKPolylineRenderer(overlay: overlay)
        line.lineWidth = 5;
        line.strokeColor = UIColor.blue
        
        return line
    }
    
}

















