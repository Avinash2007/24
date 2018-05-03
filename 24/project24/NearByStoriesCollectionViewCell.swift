//
//  NearByStoriesCollectionViewCell.swift
//  project24
//
//  Created by sri on 27/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GeoFire
import CoreLocation
import Firebase

class NearByStoriesCollectionViewCell: UICollectionViewCell, CLLocationManagerDelegate {
    
    var postId = [String]()
    
    var locationManager:CLLocationManager!
    
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    var isLocationUpdated : Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isLocationUpdated = false
        determineMyCurrentLocation()
    }
    
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        if isLocationUpdated == false{
            isLocationUpdated = true
            latitude = userLocation.coordinate.latitude
            longitude = userLocation.coordinate.longitude
            setLocation()
        }
        manager.stopUpdatingLocation()
    }
    
    func setLocation(){
        
        let uid = Auth.auth().currentUser?.uid
        let geofireRef = Database.database().reference().child("Users_Stories_locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geoFire?.setLocation(CLLocation(latitude: latitude!, longitude: longitude!), forKey: uid) { (error) in
            if (error != nil) {
                // print("An error occured: \(error)")
            } else {
                // print("Saved location successfully!")
                self.observeLocation()
            }
        }
    }
    
    func observeLocation(){
        
        let geofireRef = Database.database().reference().child("Users_Stories_locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: latitude!, longitude: longitude!)
        var circleQuery = geoFire?.query(at: center, withRadius: 5)
        
        var queryHandle = circleQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if key == Auth.auth().currentUser?.uid{
                print("nousers")
            } else{
                self.postId.append(key)
                print(self.postId.count)
                print(self.postId)
            }
            
        })
    }
    
}
