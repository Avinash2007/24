//
//  SignUpViewController.swift
//  
//
//  Created by sri on 22/07/17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Lottie
import GeoFire
import CoreLocation

class SignUpViewController: UIViewController,CLLocationManagerDelegate {
    

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signupBtnOutlet: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var locationManager:CLLocationManager!
    var latitude : CLLocationDegrees?
    var longitude : CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //buttonShape(button: signupBtnOutlet)
        //userAnimation()
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
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        print("user latitude = \(latitude)")
        print("user longitude = \(longitude)")
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func userAnimation(){
        
        let animationView = LOTAnimationView(name: "outline_user")
        animationView.frame = CGRect(x: 87.5, y: 60, width: 200, height: 200)
       // animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        
        animationView.play()
        
    }
    
    func buttonShape(button : UIButton){
        
        button.layer.cornerRadius = 8
        
        let cornerRadius: CGFloat = 8
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = UIBezierPath(
            roundedRect: button.bounds,
            byRoundingCorners: [.bottomLeft, .bottomRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath
        
        button.layer.mask = maskLayer
        
    }
    
    @IBAction func signupBtnAction(_ sender: Any) {
        activityIndicator.startAnimating()
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
            if error == nil{
                
                let profileimage : String = "https://maxcdn.icons8.com/Share/icon/Users//user_filled1600.png"
                let array : NSDictionary = ["Username" : self.usernameTextField.text , "Email" : self.emailTextField.text ,"Password" : self.passwordTextField.text,"profileImageUrl":profileimage,"latitude":self.latitude,"longitude":self.longitude]
                
                
            
                //let ref = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid

                let geofireRef = Database.database().reference().child("Users_locations")
                let geoFire = GeoFire(firebaseRef: geofireRef)
                geoFire?.setLocation(CLLocation(latitude: self.latitude!, longitude: self.longitude!), forKey: uid) { (error) in
                    if (error != nil) {
                        print("An error occured: \(error)")
                    } else {
                        print("Saved location successfully!")
                    }
                }

                
             /*
                let center = CLLocation(latitude: yourLat, longitude: yourLong)
                var circleQuery = geoFire.queryAtLocation(center, withRadius: 5)
                
                var queryHandle = circleQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
                    println("Key '\(key)' entered the search area and is at location '\(location)'")
                })
                
                */
                
                let ref = Database.database().reference()
                ref.child("Users").child(uid!).setValue(array)
                self.activityIndicator.stopAnimating()
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController")
                self.present(viewController, animated: true, completion: nil)
            }
            else if self.emailTextField.text == ""{
                    let alertController = UIAlertController(title: "oops!!!", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                    self.activityIndicator.stopAnimating()
                }
                else if self.passwordTextField.text == "" {
                    let alertController = UIAlertController(title: "oops!!!", message: "Please enter Password", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                    self.activityIndicator.stopAnimating()
                }
                else if self.usernameTextField.text == "" {
                    let alertController = UIAlertController(title: "oops!!!", message: "Please enter username", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                    self.activityIndicator.stopAnimating()
                }
                else{
                    let alertController = UIAlertController(title: "oops!!!", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                    self.activityIndicator.stopAnimating()
            }
        }
    }
    @IBAction func goBackBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
