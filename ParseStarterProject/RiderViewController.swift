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
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var callAnUberButton: UIButton!
    
    @IBAction func callAnUber(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            PFUser.logOut()
    }
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
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
        
        
            self.map.setRegion(region, animated: true)
            
            self.map.removeAnnotations(self.map.annotations) 
            
            self.map.showsUserLocation = true
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = center
            
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
