//
//  NearByUsersTableViewController.swift
//  project24
//
//  Created by sri on 19/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GeoFire
import  CoreLocation
import Firebase


class NearByUsersTableViewController: UITableViewController,CLLocationManagerDelegate {
    
    var users: [User] = []
    var userId = [String]()
    
    var locationManager:CLLocationManager!
    
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    var isLocationUpdated : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()


        isLocationUpdated = false
        fetchUsers()
        determineMyCurrentLocation()
        
        
    }
    
    func fetchUsers(){
        
        FirebaseService.sharedInstance.firebaseRef.child("Users").observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
            let dict = snapshot.value as? [String:Any]
//            print(dict)
            let user = User.transformUser(dict: dict!, key: snapshot.key)
           // print(user)
                self.users.append(user)
                self.tableView.reloadData()
            
        })
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
        let geofireRef = Database.database().reference().child("Users_locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        // var geoFire = GeoFire.firebaseRef(geofireRef)
        geoFire?.setLocation(CLLocation(latitude: latitude!, longitude: longitude!), forKey: uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
                self.observeLocation()
            }
        }
        
    }
    
    func observeLocation(){
        
        let geofireRef = Database.database().reference().child("Users_locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        let center = CLLocation(latitude: latitude!, longitude: longitude!)
        var circleQuery = geoFire?.query(at: center, withRadius: 5)
        //  5km Radius
        
        var queryHandle = circleQuery?.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            self.userId.append(key)
            print(self.userId)
            // print("Key '\(key)' entered the search area and is at location '\(location)'")
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByUserCell", for: indexPath) as! NearByTableViewCell
        
        let user = users[indexPath.row]
        cell.user = user
        //cell.delegate = self


        return cell
    }
}
