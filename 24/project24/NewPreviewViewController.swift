//
//  NewPreviewViewController.swift
//  project24
//
//  Created by sri on 25/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import ProgressHUD
import GeoFire
import CoreLocation
import FirebaseDatabase

class NewPreviewViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextField!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    
    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var folderNameLabel: UILabel!
    
    var image : UIImage?
    var previewVideoUrl : NSURL?
    var previewFolderName :String?
    var previewFolderImage : UIImage?

    var locationManager:CLLocationManager!
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        previewImageView.image = self.image
        folderImageView.image = self.previewFolderImage
        folderNameLabel.text = self.previewFolderName
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
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    @IBAction func backButtonAction(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
    }
    @IBAction func sendButtonAction(_ sender: Any) {
        
        ProgressHUD.show("wating...", interaction: false)

            if let storiesImage = previewImageView.image{
            
            let timeStamp = NSDate().timeIntervalSince1970
            let shoutTime = Int(timeStamp)
            let deleteTime = Int(timeStamp.adding(24*60*60))
                
                
                StoriesFirebaseService.sharedInstance.stories(storiesImage: storiesImage, folderImage: previewFolderImage!, storiesDetails: ["Caption":captionTextView.text,"UploadTime" : shoutTime,"DeleteTime" : deleteTime,"FolderName":previewFolderName], completionBlock: { (StoriesId,  folderImageUrl, folderId) in
                    
                    Database.database().reference().child("Folders").child(folderId).setValue(["FolderName" : self.previewFolderName , "FolderImageUrl" :  folderImageUrl,"FolderId" : folderId])
                    
                    self.storiesLocation(StoriesId: StoriesId)
                    ProgressHUD.showSuccess()
                    self.captionTextView.text = ""
                    self.previewImageView.image = nil
                    let viewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
                    self.present(viewController , animated: true, completion: nil)
            })
        }
        else {
            ProgressHUD.showError("Shout can't be empty")
        }
    }
    
    func storiesLocation(StoriesId:String){
   
        let geofireRef = Database.database().reference().child("Users_Stories_locations")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        geoFire?.setLocation(CLLocation(latitude: self.latitude!, longitude: self.longitude!), forKey: StoriesId) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
    }
}



/*

@IBAction func sendButtonAction(_ sender: Any) {
    
    ProgressHUD.show("wating...", interaction: false)
    //        if previewVideoUrl != nil {
    //
    //            let timeStamp = NSDate().timeIntervalSince1970
    //            let uploadTime = Int(timeStamp)
    //            let deleteTime = Int(timeStamp.adding(24*60*60))
    //
    //            var values = ["uploadTime":uploadTime,"deleteTime" : deleteTime,"caption":captionTextView.text] as [String : Any]
    //
    ////            let storyId = ""
    ////
    ////            let geofireRef = Database.database().reference().child("Users_Stories_locations")
    ////            let geoFire = GeoFire(firebaseRef: geofireRef)
    ////            geoFire?.setLocation(CLLocation(latitude: self.latitude!, longitude: self.longitude!), forKey: storyId) { (error) in
    ////                if (error != nil) {
    ////                    print("An error occured: \(error)")
    ////                } else {
    ////                    print("Saved location successfully!")
    ////                }
    ////            }
    //
    //            FirebaseService.sharedInstance.postVideo(uploadVideoUrl: previewVideoUrl!, properties: values as! NSMutableDictionary, completionBlock: { (snapshot) in
    //                ProgressHUD.showSuccess()
    //                self.captionTextView.text = ""
    //
    //
    //            })
    //        } else
    if let shoutImage = previewImageView.image{
        
        let timeStamp = NSDate().timeIntervalSince1970
        let shoutTime = Int(timeStamp)
        let deleteTime = Int(timeStamp.adding(24*60*60))
        
        FirebaseService.sharedInstance.stories(storiesImage: shoutImage, storiesDetails: ["Caption":captionTextView.text,"UploadTime" : shoutTime,"DeletTime" : deleteTime,"FolderName":previewFolderName], completionBlock: { (StoriesId) in
            
            self.storiesLocation(StoriesId: StoriesId)
            ProgressHUD.showSuccess()
            self.captionTextView.text = ""
            self.previewImageView.image = nil
            let viewController  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
            self.present(viewController , animated: true, completion: nil)
        })
    }
    else {
        ProgressHUD.showError("Shout can't be empty")
    }
}

*/
