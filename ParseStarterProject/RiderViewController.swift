//
//  RiderViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Varun Babu on 16/4/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class RiderViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var callAnUberButton: UIButton!
    
    @IBAction func callAnUber(_ sender: Any) {
        
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            
            let riderRequest =  PFObject(className:"RiderRequest")
        
            riderRequest["username"] = PFUser.current()?.username
        
            riderRequest["currentLocation"] = PFGeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            riderRequest.saveInBackground(block: { (success, error) in
                
                if success{
                    
                    print("Called an Uber")
                    
                }
                else{
                    
                    self.displayAlert(title: "Could not call uber", message: "Please try again")
                    
                }
                
                
            })
        
        }
        else{
            
            displayAlert(title: "Could not call an uber", message: "Cannot detect your location")
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
    }
    }
    
    
    
    func displayAlert(title: String, message: String){
        
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertcontroller, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        
        locationManager.startUpdatingLocation()
        
    
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        
        if let location = manager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
        
        
            self.map.setRegion(region, animated: true)
            
            self.map.removeAnnotations(self.map.annotations)
            
            self.map.showsUserLocation = true
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = userLocation
            
            annotation.title = "Your location"
            
            self.map.addAnnotation(annotation)
            
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
