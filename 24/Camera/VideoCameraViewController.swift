//
//  VideoCameraViewController.swift
//  24
//
//  Created by sri on 28/12/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
import PhotosUI


class VideoCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate, UINavigationControllerDelegate {
    
        var swipeGesture  = UISwipeGestureRecognizer()
    
    var captureSession = AVCaptureSession()
    
    var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
    
    var startVideoCapturing = Bool()
    
    
    var cameraPosition = Bool()
    
    var photoInput : AVCaptureDeviceInput?
    
    var seconds = 1
    var timer = Timer()
    
    
    @IBOutlet weak var captureVideoOutlet: UIView!
    @IBOutlet weak var frontCameraImgView: UIImageView!
    
    lazy var frontCameraDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        if cameraPosition == false {
            return devices.filter{$0.position == .back}.first
        } else{
            return devices.filter{$0.position == .front}.first
        }
        
        
    }()
    
    lazy var removeDevice: AVCaptureDevice? = {
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        if cameraPosition == true {
            return devices.filter{$0.position == .back}.first
        } else{
            return devices.filter{$0.position == .front}.first
        }
        
        
    }()
    
    lazy var micDevice: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: AVMediaType.audio)
    }()
    
    var movieOutput = AVCaptureMovieFileOutput()
    
    private var tempFilePath: URL = {
        
        
        let tempPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tempFile").appendingPathExtension("mp4").absoluteString
        
        if FileManager.default.fileExists(atPath: tempPath) {
            do {
                try FileManager.default.removeItem(atPath: tempPath)
            } catch { }
        }
        return URL(string: tempPath)!
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        startVideoCapturing = true
        
        cameraPosition = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forntCamera))
        
        frontCameraImgView.isUserInteractionEnabled = true
        frontCameraImgView.addGestureRecognizer(tapGestureRecognizer)
        
        let captureVideo = UITapGestureRecognizer(target: self, action: #selector(captureVideoAction))
        
        captureVideoOutlet.isUserInteractionEnabled = true
        captureVideoOutlet.addGestureRecognizer(captureVideo)
        
        captureVideoOutlet.layer.borderColor = UIColor.white.cgColor
        
        //start session configuration
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // add device inputs (front camera and mic)
        captureSession.addInput(deviceInputFromDevice(device: frontCameraDevice)!)
        captureSession.addInput(deviceInputFromDevice(device: micDevice)!)
        
        // add output movieFileOutput
        movieOutput.movieFragmentInterval = kCMTimeInvalid
        captureSession.addOutput(movieOutput)
        
        // start session
        captureSession.commitConfiguration()
        captureSession.startRunning()
        setupPreviewLayer()
        setupPreviewLayer()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                //ex()
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
   @objc func forntCamera(){

   
    if cameraPosition == true {
        captureSession.addInput(deviceInputFromDevice(device: frontCameraDevice)!)
        cameraPosition = false
        
    } else {
        captureSession.addInput(deviceInputFromDevice(device: frontCameraDevice)!)
         cameraPosition = true
        }
    
    
    }
    
    
    // To display camera opn the screen
    func setupPreviewLayer(){
        cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewlayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewlayer!, at: 0)
    }

    private func deviceInputFromDevice(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let outError {
            print("Device setup error occured \(outError)")
            return nil
        }
    }
    private func removeInputFromDevice(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let outError {
            print("Device setup error occured \(outError)")
            return nil
        }
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil)
        {
            print("Unable to save video to the iPhone  \(String(describing: error?.localizedDescription))")
        }
        else
        {
            
            
    PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
   @objc func captureVideoAction(){
        
        if startVideoCapturing == true {
            movieOutput.startRecording(to: tempFilePath as URL, recordingDelegate: self)
            startVideoCapturing = false
            runTimer()
        } else {
            
            movieOutput.stopRecording()
            startVideoCapturing = true
            seconds = 0
            timer.invalidate()
            
        }
    }
    

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1     //This will decrement(count down)the seconds.
       // print("\(seconds)") //This will update the label
        print("\(timeString(time: TimeInterval(seconds)))")
    }
    func timeString(time:TimeInterval) -> String {
       // let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    /*
    func ex(){
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC1") as! NormalCameraViewController
        greenVC.isHeroEnabled = true
        greenVC.heroModalAnimationType = .fade
        self.hero_replaceViewController(with: greenVC)
    }
  */
}

/*
 import UIKit
 import AVFoundation
 import MobileCoreServices
 import Hero
 
 class NormalCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate {
 
 var swipeGesture  = UISwipeGestureRecognizer()
 
 var captureSession = AVCaptureSession()
 
 var backCamera : AVCaptureDevice?
 var frontCamera : AVCaptureDevice?
 var currentCamera : AVCaptureDevice?
 
 var photoOutput : AVCapturePhotoOutput?
 var photoInput : AVCaptureDeviceInput?
 
 
 var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
 
 var captureImage = UIImage()
 
 var capturedImage : UIImage?
 var cameraPosition = Bool()
 
 
 
 @IBOutlet weak var capturePhotoView: UIView!
 @IBOutlet weak var frontCameraButtonImageView: UIImageView!
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
 swipeRight.direction = UISwipeGestureRecognizerDirection.right
 self.view.addGestureRecognizer(swipeRight)
 
 cameraPosition = false
 
 let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(capturePhoto))
 let FrontCameraTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forntCamera))
 
 capturePhotoView.isUserInteractionEnabled = true
 capturePhotoView.addGestureRecognizer(tapGestureRecognizer)
 
 frontCameraButtonImageView.isUserInteractionEnabled = true
 frontCameraButtonImageView.addGestureRecognizer(FrontCameraTapGestureRecognizer)
 
 capturePhotoView.layer.borderColor = UIColor.white.cgColor
 
 
 let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
 let blurEffectView = UIVisualEffectView(effect: blurEffect)
 blurEffectView.frame = capturePhotoView.bounds
 blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 capturePhotoView.addSubview(blurEffectView)
 
 setupCaptureSession()
 setupDevice()
 setupInputOutput()
 setupPreviewLayer()
 startRunningCaptureSession()
 
 }
 
 @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
 
 if let swipeGesture = gesture as? UISwipeGestureRecognizer {
 
 
 switch swipeGesture.direction {
 case UISwipeGestureRecognizerDirection.right:
 print("Swiped right")
 animation()
 case UISwipeGestureRecognizerDirection.down:
 print("Swiped down")
 
 case UISwipeGestureRecognizerDirection.left:
 print("Swiped left")
 case UISwipeGestureRecognizerDirection.up:
 print("Swiped up")
 default:
 break
 }
 }
 }
 
 
 @objc func capturePhoto(){
 
 photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
 
 
 print("dooone")
 
 }
 
 @objc func forntCamera(){
 
 
 print("done")
 
 
 self.captureSession.beginConfiguration()
 self.cameraPosition = !cameraPosition
 if photoInput != nil {
 self.captureSession.removeInput(photoInput!)
 
 }
 if photoOutput != nil {
 
 self.captureSession.removeOutput(photoOutput!)
 
 }
 self.setupDevice()
 self.setupInputOutput()
 self.captureSession.commitConfiguration()
 
 
 
 }
 
 // Image Quality and resolution
 func setupCaptureSession() {
 captureSession.sessionPreset = AVCaptureSession.Preset.photo
 }
 // To represent which type of camera device
 func setupDevice(){
 
 
 let deviceDiscoverySession  = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
 
 let devices = deviceDiscoverySession.devices
 
 for device in devices {
 if device.position == AVCaptureDevice.Position.front {
 frontCamera = device
 
 }else  if device.position == AVCaptureDevice.Position.back {
 backCamera = device
 
 }
 
 if cameraPosition == true {
 
 currentCamera = frontCamera
 
 } else{
 currentCamera = backCamera
 
 
 }
 }
 }
 
 // Takes capture devices and connect to capture session
 func setupInputOutput(){
 
 do {
 
 let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
 photoInput = captureDeviceInput
 captureSession.addInput(captureDeviceInput)
 photoOutput = AVCapturePhotoOutput()
 photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
 captureSession.addOutput(photoOutput!)
 
 } catch{
 print(error.localizedDescription)
 }
 }
 
 // To display camera opn the screen
 func setupPreviewLayer(){
 cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
 cameraPreviewlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
 cameraPreviewlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
 cameraPreviewlayer?.frame = self.view.frame
 self.view.layer.insertSublayer(cameraPreviewlayer!, at: 0)
 }
 
 func startRunningCaptureSession(){
 captureSession.startRunning()
 }
 
 func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
 
 // Make sure we get some photo sample buffer
 guard error == nil,
 let photoSampleBuffer = photoSampleBuffer else {
 print("Error capturing photo: \(String(describing: error))")
 return
 }
 // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
 guard let imageData =
 AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
 return
 }
 
 
 // Initialise a UIImage with our image data
 capturedImage = UIImage.init(data: imageData , scale: 1.0)
 if let image = capturedImage {
 // Save our captured image to photos album
 UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
 
 performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
 }
 }
 
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
 if segue.identifier == "PreviewPhotoSegue"{
 
 
 
 let previewVc = segue.destination as! PreviewCameraViewController
 previewVc.capturedImage = self.capturedImage
 }
 }
 
 func animation(){
 let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VC2") as! VideoCameraViewController
 greenVC.isHeroEnabled = true
 greenVC.heroModalAnimationType = .fade
 // .fade(direction: HeroDefaultAnimationType.Direction.left)
 self.hero_replaceViewController(with: greenVC)
 }
 
 
 }
 
 */
