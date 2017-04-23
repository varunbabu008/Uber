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
    
    var riderRequestActive = true
    
    var driverOnTheWay = false
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var callAnUberButton: UIButton!
    
    @IBAction func callAnUber(_ sender: Any) {
        
        
        if riderRequestActive{
            
            callAnUberButton.setTitle("Call an Uber", for: [])
            
            riderRequestActive = false
            
            let query = PFQuery(className: "RiderRequest")
            query.whereKey("username", equalTo: (PFUser.current()?.username)!)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects{
                    
                    for riderRequest in riderRequests{
                            
                            riderRequest.deleteInBackground()
                            
                            
                        }
                    }
                
            })
        
        }
        
        else{
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            
            riderRequestActive = true
            
            self.callAnUberButton.setTitle("Cancel Uber", for: [])

            
            let riderRequest =  PFObject(className:"RiderRequest")
        
            riderRequest["username"] = PFUser.current()?.username
        
            riderRequest["currentLocation"] = PFGeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            riderRequest.saveInBackground(block: { (success, error) in
                
                if success{
                    
                    print("Called an Uber")
                    
                    
                }
                else{
                    
                    self.callAnUberButton.setTitle("Call an Uber", for: [])
                    
                    self.riderRequestActive = false

                    
                    self.displayAlert(title: "Could not call uber", message: "Please try again")
                    
                }
                
                
            })
        
        }
        else{
            
            displayAlert(title: "Could not call an uber", message: "Cannot detect your location")
            
        }
         
    }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            
            locationManager.stopUpdatingLocation()
            
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
        
        callAnUberButton.isHidden = true
        
        let query = PFQuery(className: "RiderRequest")
        query.whereKey("username", equalTo: (PFUser.current()?.username)!)
        
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if let objects = objects{
                if objects.count > 0
                {
                    
               
                self.riderRequestActive = true
                
                self.callAnUberButton.setTitle("Cancel an Uber", for: [])
               
                }
            }
            
            self.callAnUberButton.isHidden = false
            
        })

        
    
        
        
        

        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        
        if let location = manager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            if driverOnTheWay == false{
                
            
            
                let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
        
        
                self.map.setRegion(region, animated: true)
            
                self.map.removeAnnotations(self.map.annotations)
            
                self.map.showsUserLocation = true
            
                let annotation = MKPointAnnotation()
            
                annotation.coordinate = userLocation
            
                annotation.title = "Your location"
            
                self.map.addAnnotation(annotation)
            
            }
            
            // Updating the users location
            let query = PFQuery(className: "RiderRequest")
            query.whereKey("username", equalTo: (PFUser.current()?.username)!)
            
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let riderRequests = objects{
                    
                    for riderRequest in riderRequests{
                        
                        riderRequest["currentLocation"] = PFGeoPoint(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                        
                        riderRequest.saveInBackground()
                        
                        
                    }
                }
                
            })
            
            
            
        }
        
        
        if riderRequestActive == true{
            
            let query = PFQuery(className: "RiderRequest")
            
            query.whereKey("username", equalTo: PFUser.current()?.username)
            
            query.findObjectsInBackground(block: { (objects, error) in
                if let riderRequests = objects{
                    
                    for riderRequest in riderRequests{
                        
                        if let driverUsername = riderRequest["driverResponded"]{
                            
                            let query = PFQuery(className: "DriverLocation")
                            
                            query.whereKey("username", equalTo: driverUsername)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let driverLocations = objects{
                                    
                                    for driverLocationObject in driverLocations{
                                        
                                        if let driverLocation = driverLocationObject["location"] as? PFGeoPoint{
                                            
                                            self.driverOnTheWay = true
                                            
                                            let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                            
                                            let riderCLLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                                            
                                            
                                            let distance = riderCLLocation.distance(from: driverCLLocation) / 1000
                                            
                                            let roundedDistance = round(distance * 100)/100
                                            
                                            
                                            
                                            self.callAnUberButton.setTitle("Your Driver is \(roundedDistance) km away", for: [])
                                            
                                            let latDelta = abs(driverLocation.latitude - self.userLocation.latitude) * 2 + 0.005
                                            
                                            let lonDelta = abs(driverLocation.longitude - self.userLocation.longitude) * 2 + 0.005

                                            let region = MKCoordinateRegion(center: self.userLocation, span: MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta))
                                            
                                            self.map.removeAnnotations(self.map.annotations)
                                            
                                            self.map.setRegion(region, animated: true)
                                            
                                            let userLocationAnnotation = MKPointAnnotation()
                                            
                                            userLocationAnnotation.coordinate = self.userLocation
                                            
                                            userLocationAnnotation.title = "Your location"
                                            
                                            self.map.addAnnotation(userLocationAnnotation)
                                            
                                            
                                            let driverLocationAnnotation = MKPointAnnotation()
                                            
                                            driverLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                            
                                            driverLocationAnnotation.title = "Your driver"
                                            
                                            self.map.addAnnotation(driverLocationAnnotation)
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            })
                            
                        }
                        
                        
                    }
                    
                    
                }
            })
            
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
