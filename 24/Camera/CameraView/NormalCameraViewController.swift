////
////  NormalCameraViewController.swift
////  24
////
////  Created by sri on 28/12/17.
////  Copyright © 2017 sri. All rights reserved.
////
//
//
//
//import UIKit
//import AVFoundation
//import Photos
//import SwiftyCam
//
//class NormalCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate{
//
//
//    @IBOutlet weak var captureActionView: UIView!
//
//    @IBOutlet weak var camView: UIView!
//
//    @IBOutlet weak var cameraControlsViewOutlet: UIView!
//
//    @IBOutlet weak var ISOControlActionOutlet: UIButton!
//    @IBOutlet weak var focusCameraControlActionOutlet: UIButton!
//    @IBOutlet weak var exposureCameraControlActionOutlet: UIButton!
//    @IBOutlet weak var whiteBalanceCameraControlActionOutlet: UIButton!
//
//    @IBOutlet weak var sliderOutlet: UISlider!
//    @IBOutlet weak var sliderValueLabel: UILabel!
//
//    @IBOutlet weak var momentLabel: UILabel!
//    @IBOutlet weak var openMomentsListBtnOutlet: UIButton!
//
//    @IBOutlet weak var openPhotoCaptureBtnOutlet: UIButton!
//    @IBOutlet weak var openVideoCaptureBtnOutlet: UIButton!
//    @IBOutlet weak var openCustomControlsBtnOutlet: UIButton!
//
//    @IBOutlet weak var toogleCaptureViewOutlet: UIView!
//    @IBOutlet weak var tooglecaptureBarViewOutlet: UIView!
//
//    @IBOutlet weak var swtichCameraBtnOutlet: UIButton!
//    @IBOutlet weak var flashBtnOutlet: UIButton!
//
//    var captureDevice : AVCaptureDevice?
//    var captureSession = AVCaptureSession()
//    var stillImageOutput: AVCaptureStillImageOutput?
//
//    var previewLayer : AVCaptureVideoPreviewLayer? // to add video inside container
//
//    var seconds = 0
//    var timer = Timer()
//
//    var capturedImage = UIImage()
//
//    var cameraType: Int = 0
//
//    var tag = Int()
//
//    var isRecordingVideo = false
//
//    var videoRecordedUrl : URL!
//
//    let movieOutput = AVCaptureMovieFileOutput()
//
//    var activeInput: AVCaptureDeviceInput!
//
//    var outputURL: URL!
//
//    // which camera input do we want to use
//    var backFacingCamera: AVCaptureDevice?
//    var frontFacingCamera: AVCaptureDevice?
//    var currentDevice: AVCaptureDevice?
//
//    var capturePhotoOutput: AVCapturePhotoOutput?
//
//    // output device
//    //var stillImageOutput: AVCaptureStillImageOutput?
//    var stillImage: UIImage?
//
//    // camera preview layer
//    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
//
//
//    // double tap to switch from back to front facing camera
//    var toggleCameraGestureRecognizer = UITapGestureRecognizer()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//
//        tapGestures()
//        cameraSetup()
//        sliderStyle()
//
//        ////
////        if setupSession() {
////            setupPreview()
////            startSession()
////        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        UIApplication.shared.isStatusBarHidden = true
//
//        self.tabBarController?.tabBar.isHidden = true
//
//        cameraControlsViewOutlet.isHidden = true
//        sliderValueLabel.isHidden = true
//        sliderOutlet.isHidden = true
//        momentLabel.isHidden = false
//
//        swtichCameraBtnOutlet.isHidden = false
//        flashBtnOutlet.isHidden = false
//
//        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//
//        openPhotoCaptureBtnOutlet.frame = CGRect(x: 0, y: 10, width: (screenSize.width / 3), height: 40)
//        openVideoCaptureBtnOutlet.frame = CGRect(x: openPhotoCaptureBtnOutlet.frame.width, y: 10, width: (screenSize.width / 3), height: 40)
//        openCustomControlsBtnOutlet.frame = CGRect(x: (openVideoCaptureBtnOutlet.frame.width * 2), y: 10, width: (screenSize.width / 3), height: 40)
//
//        toogleCaptureViewOutlet.frame = CGRect(x: 0, y: (screenSize.height - 50), width: screenSize.width, height: 50)
//        tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
//
//        captureBtnStyle()
//        captureBtnAllignment()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        UIApplication.shared.isStatusBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//    }
//
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
//
//    func cameraSetup(){
//
//        // Do any additional setup after loading the view, typically from a nib.
//        captureSession.sessionPreset = AVCaptureSession.Preset.high
//
//        let devices = AVCaptureDevice.devices()
//
//        // Loop through all the capture devices on this phone
//        for device in devices {
//
//            if device.position == .back {
//                backFacingCamera = device
//            } else if device.position == .front {
//                frontFacingCamera = device
//            }
//            // Make sure this particular device supports video
//            if (device.hasMediaType(AVMediaType.video)) {
//                // Finally check the position and confirm we've got the back camera
//                if(device.position == AVCaptureDevice.Position.back) {
//                    captureDevice = device as? AVCaptureDevice
//                    if captureDevice != nil {
//                        print("Capture device found")
//                        beginSession()
//                    }
//                }
//            }
//        }
//
//        currentDevice = frontFacingCamera
//    }
//
//    func tapGestures(){
//
//        let capturePhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(capturePhoto))
//        captureActionView.isUserInteractionEnabled = true
//        captureActionView.addGestureRecognizer(capturePhotoTapGestureRecognizer)
//
//    }
//
//    func captureBtnStyle(){
//
//        captureActionView.layer.borderWidth = 20.0
//        captureActionView.layer.borderColor = UIColor.white.cgColor
//
//    }
//
//    func captureBtnAllignment(){
//
//        captureActionView.frame = CGRect(x: (screenSize.width / 2) - 30, y: screenSize.height - 130, width: 60, height: 60)
//
//    }
//
//    func sliderStyle(){
//
//        sliderOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
//
//    }
//
//    ////
////    func setupPreview() {
////        // Configure previewLayer
////        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
////        cameraPreviewLayer?.frame = camView.bounds
////        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
////        camView.layer.addSublayer(cameraPreviewLayer!)
////    }
////
//    ////
////    func setupSession() -> Bool {
////
////        captureSession.sessionPreset = AVCaptureSession.Preset.high
////
////        // Setup Camera
////        let camera = AVCaptureDevice.default(for: .video)
////
////        do {
////            let input = try AVCaptureDeviceInput(device: camera!)
////            if captureSession.canAddInput(input) {
////                captureSession.addInput(input)
////                activeInput = input
////            }
////        } catch {
////            print("Error setting device video input: \(error)")
////            return false
////        }
////
////        // Setup Microphone
////        let microphone = AVCaptureDevice.default(for: .audio)
////
////        do {
////            let micInput = try AVCaptureDeviceInput(device: microphone!)
////            if captureSession.canAddInput(micInput) {
////                captureSession.addInput(micInput)
////            }
////        } catch {
////            print("Error setting device audio input: \(error)")
////            return false
////        }
////
////
////        // Movie output
////        if captureSession.canAddOutput(movieOutput) {
////            captureSession.addOutput(movieOutput)
////        }
////
////        return true
////    }
//
//    ////
//    //MARK:- Camera Session
////    func startSession() {
////        if !captureSession.isRunning {
////            videoQueue().async {
////                self.captureSession.startRunning()
////            }
////        }
////    }
////
////    func stopSession() {
////        if captureSession.isRunning {
////            videoQueue().async {
////                self.captureSession.stopRunning()
////            }
////        }
////    }
//
////    func videoQueue() -> DispatchQueue {
////        return DispatchQueue.main
////    }
//
////    func currentVideoOrientation() -> AVCaptureVideoOrientation {
////        var orientation: AVCaptureVideoOrientation
////
////        switch UIDevice.current.orientation {
////        case .portrait:
////            orientation = AVCaptureVideoOrientation.portrait
////        case .landscapeRight:
////            orientation = AVCaptureVideoOrientation.landscapeLeft
////        case .portraitUpsideDown:
////            orientation = AVCaptureVideoOrientation.portraitUpsideDown
////        default:
////            orientation = AVCaptureVideoOrientation.landscapeRight
////        }
////
////        return orientation
////    }
//
////    func startCapture() {
////
////        startRecording()
////
////    }
//
////    func tempURL() -> URL? {
////        let directory = NSTemporaryDirectory() as NSString
////
////        if directory != "" {
////            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
////            return URL(fileURLWithPath: path)
////        }
////
////        return nil
////    }
//
//
////    func startRecording() {
////        print("started")
////        if movieOutput.isRecording == false {
////
////            let connection = movieOutput.connection(with: AVMediaType.video)
////            if (connection?.isVideoOrientationSupported)! {
////                connection?.videoOrientation = currentVideoOrientation()
////            }
////
////            if (connection?.isVideoStabilizationSupported)! {
////                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
////            }
////
////            let device = activeInput.device
////            if (device.isSmoothAutoFocusSupported) {
////                do {
////                    try device.lockForConfiguration()
////                    device.isSmoothAutoFocusEnabled = false
////                    device.unlockForConfiguration()
////                } catch {
////                    print("Error setting configuration: \(error)")
////                }
////
////            }
////
////            outputURL = tempURL()
////            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
////
////        }
////        else {
////            stopRecording()
////        }
////
////    }
//
////    @objc func stopRecording() {
////        print("stopped")
////        if movieOutput.isRecording == true {
////            movieOutput.stopRecording()
////        }
////    }
////
////    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
////        if (error != nil) {
////            print("Error recording movie: \(error!.localizedDescription)")
////        } else {
////          //  _ = outputURL as URL
////
////            videoRecordedUrl = outputURL! as URL
////            self.performSegue(withIdentifier: "PreviewPhotoSegue", sender: self)
////
////        }
////       // outputURL = nil
////    }
//
//    func configureDevice() {
//        let error: NSErrorPointer = nil
//        if let device = captureDevice {
//            //device.lockForConfiguration(nil)
//
//            do {
//                try captureDevice!.lockForConfiguration()
//
//            } catch let error1 as NSError {
//                // error.memory = error1
//            }
//
//            device.focusMode = .continuousAutoFocus
//            device.unlockForConfiguration()
//        }
//    }
//
//    func beginSession() {
//        configureDevice()
//        var err : NSError? = nil
//
//        var deviceInput: AVCaptureDeviceInput!
//        do {
//            deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
//
//        } catch let error as NSError {
//            err = error
//            deviceInput = nil
//        };
//
//        captureSession.addInput(deviceInput)
//
//        if err != nil {
//            print("error: \(err?.localizedDescription)")
//        }
//
//        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//
//        self.camView.layer.addSublayer(cameraPreviewLayer!)
//        cameraPreviewLayer?.frame = self.camView.layer.frame
//        captureSession.startRunning()
//
//    }
//
//    @objc private func toggleCamera() {
//        // start the configuration change
//        captureSession.beginConfiguration()
//
//        let newDevice = (currentDevice?.position == . back) ? frontFacingCamera : backFacingCamera
//
//        for input in captureSession.inputs {
//            captureSession.removeInput(input as! AVCaptureDeviceInput)
//        }
//
//        let cameraInput: AVCaptureDeviceInput
//        do {
//            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
//        } catch let error {
//            print(error)
//            return
//        }
//
//        if captureSession.canAddInput(cameraInput) {
//            captureSession.addInput(cameraInput)
//        }
//
//        currentDevice = newDevice
//        captureSession.commitConfiguration()
//    }
//
//    @objc func capturePhoto(){
//
//
//        if cameraType == 0{
//
//            print("capture---photo")
//
//            var stillImageOutput = AVCaptureStillImageOutput.init()
//            if #available(iOS 11.0, *) {
//                stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
//            } else {
//                // Fallback on earlier versions
//            }
//            self.captureSession.addOutput(stillImageOutput)
//
//            if let videoConnection = stillImageOutput.connection(with:AVMediaType.video){
//                stillImageOutput.captureStillImageAsynchronously(from:videoConnection, completionHandler: {
//                    (sampleBuffer, error) in
//                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer!)
//                    var dataProvider = CGDataProvider.init(data: imageData as! CFData)
//                    var cgImageRef = CGImage.init(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
//                    var image = UIImage.init(cgImage: cgImageRef!, scale: 1.0, orientation: .right)
//                    // do something with image
//                    self.stillImage = image
//                    self.performSegue(withIdentifier: "PreviewPhotoSegue", sender: self)
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                    print("captured")
//
//                })
//            }
//
//        } else if cameraType == 1{
//
//
//
//        } else if cameraType == 2{
//
//
//
//        }
//    }
//
////    @objc func startRecordVideo(){
////
////         if !self.isRecordingVideo {
////
////        self.isRecordingVideo = true
////        startRecording()
////        print("start")
////         }
////    }
//
//    func runTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
//    }
//
//    @objc func updateTimer() {
//        seconds += 1
//        print("\(timeString(time: TimeInterval(seconds)))")
//    }
//
//    func timeString(time:TimeInterval) -> String {
//        // let hours = Int(time) / 3600
//        let minutes = Int(time) / 60 % 60
//        let seconds = Int(time) % 60
//        return String(format: "%02i:%02i", minutes, seconds)
//    }
//
////    @objc func longPressByUser(with recongniser:UILongPressGestureRecognizer) {
////
////        if recongniser.state == .began {
////
////            print("Began,start")
////            startRecordVideo()/////////////////////////////////////////////////
////
////        } else if recongniser.state == .ended {
////
////            stopRecording()///////////////////////////////////////////////////
////            print("stop,ended")
////        }
////    }
////
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "PreviewPhotoSegue"{
//            let previewVc = segue.destination as! PreviewCameraViewController
//            previewVc.capturedImage = self.stillImage
//            //previewVc.momentId = self.momentId
//           // previewVc.videoURL = videoRecordedUrl
//        }
//    }
//
//    func updateDeviceSettings(focusValue : Float, isoValue : Float) {
//        let error: NSErrorPointer = nil
//
//        if let device = captureDevice {
//            do {
//                try captureDevice!.lockForConfiguration()
//
//            } catch let error1 as NSError {
//                // error?.memory = error1
//            }
//
//            device.setFocusModeLocked(lensPosition: focusValue, completionHandler: { (time) -> Void in
//                //
//            })
//
//            // Adjust the iso to clamp between minIso and maxIso based on the active format
//            let minISO = device.activeFormat.minISO
//            let maxISO = device.activeFormat.maxISO
//            let clampedISO = isoValue * (maxISO - minISO) + minISO
//
//            var minDur = device.activeFormat.minExposureDuration
//            var maxDur = device.activeFormat.maxExposureDuration
//
//            print (minDur)
//            print (maxDur)
//
//            //            CMTimeMake(1, 5)
//
//            device.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration , iso: clampedISO, completionHandler: { (time) -> Void in
//                //
//            })
//
//            device.unlockForConfiguration()
//        }
//    }
//
//    func focusTo(value : Float) {
//        let error: NSErrorPointer = nil
//
//
//        if let device = captureDevice {
//            do {
//                try captureDevice!.lockForConfiguration()
//
//            } catch let error1 as NSError {
//                // error?.memory = error1
//            }
//
//            device.setFocusModeLocked(lensPosition: value, completionHandler: { (time) -> Void in
//                //
//            })
//            device.unlockForConfiguration()
//        }
//    }
//
//    func updateDeviceDuration(focusValue : Float, isoValue : Float, exposure : Float) {
//        let error: NSErrorPointer = nil
//
//        if let device = captureDevice {
//            do {
//                try captureDevice!.lockForConfiguration()
//
//            } catch let error1 as NSError {
//                // error?.memory = error1
//            }
//
//            device.setFocusModeLocked(lensPosition: focusValue, completionHandler: { (time) -> Void in
//                //
//            })
//
//            // Adjust the iso to clamp between minIso and maxIso based on the active format
//            let minISO = device.activeFormat.minISO
//            let maxISO = device.activeFormat.maxISO
//            let clampedISO = isoValue * (maxISO - minISO) + minISO
//
//            var minDur = device.activeFormat.minExposureDuration
//            var maxDur = device.activeFormat.maxExposureDuration
//
//            print (minDur)
//            print (maxDur)
//
//            device.setExposureModeCustom(duration:CMTimeMake(1, Int32(exposure)) , iso: clampedISO, completionHandler: { (time) -> Void in
//                //
//            })
//
//            device.unlockForConfiguration()
//        }
//    }
//
//    @IBAction func switchCamera(_ sender: Any) {
//        toggleCamera()
//    }
//
//    @IBAction func flashBtnAction(_ sender: Any) {
//    }
//
//    @IBAction func cancelBtnAction(_ sender: Any) {
//        print("tapped")
//        tabBarController?.selectedIndex = 0
//    }
//
//    @IBAction func openMomentsListBtnAction(_ sender: Any) {
//
//        momentLabel.isHidden = false
//        cameraControlsViewOutlet.isHidden = true
//        sliderValueLabel.isHidden = true
//        sliderOutlet.isHidden = true
//        print("openGoTo")
//
//        self.performSegue(withIdentifier: "goToViewMomentsViewController", sender: nil)
//    }
//
//    @IBAction func openPhotoCaptureBtnAction(_ sender: Any) {
//
//        cameraControlsViewOutlet.isHidden = true
//        sliderValueLabel.isHidden = true
//        sliderOutlet.isHidden = true
//        swtichCameraBtnOutlet.isHidden = false
//        flashBtnOutlet.isHidden = false
//
//        cameraType = 0
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
//        }, completion: nil)
//
//        tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
//
//        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//
//        openPhotoCaptureBtnOutlet.setTitleColor(.white, for: .normal)
//        openVideoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
//        openCustomControlsBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
//
//        captureActionView.layer.borderWidth = 20.0
//        captureActionView.layer.borderColor = UIColor.white.cgColor
//        captureActionView.backgroundColor = UIColor.clear
//
//    }
//    @IBAction func openVideoCaptureBtnAction(_ sender: Any) {
//
//        cameraControlsViewOutlet.isHidden = true
//        sliderValueLabel.isHidden = true
//        sliderOutlet.isHidden = true
//        swtichCameraBtnOutlet.isHidden = false
//        flashBtnOutlet.isHidden = false
//
//        cameraType = 1
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.tooglecaptureBarViewOutlet.frame = CGRect(x: self.openPhotoCaptureBtnOutlet.frame.width, y: 5, width: (screenSize.width / 3), height: 2)
//        }, completion: nil)
//
//
//        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//
//        openPhotoCaptureBtnOutlet.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
//        openVideoCaptureBtnOutlet.setTitleColor(.white, for: .normal)
//        openCustomControlsBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
//
//        captureActionView.layer.borderWidth = 20.0
//        captureActionView.layer.borderColor = UIColor.red.cgColor
//        captureActionView.backgroundColor = UIColor.white
//
//    }
//    @IBAction func openCustomControlsBtnAction(_ sender: Any) {
//
//        cameraControlsViewOutlet.isHidden = false
//        sliderValueLabel.isHidden = false
//        sliderOutlet.isHidden = false
//        swtichCameraBtnOutlet.isHidden = true
//        flashBtnOutlet.isHidden = true
//
//        cameraType = 2
//
//        UIView.animate(withDuration: 0.2, animations: {
//            self.tooglecaptureBarViewOutlet.frame = CGRect(x: (self.openPhotoCaptureBtnOutlet.frame.width * 2), y: 5, width: (screenSize.width / 3), height: 2)
//        }, completion: nil)
//
//        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
//        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
//
//        openPhotoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
//        openVideoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
//        openCustomControlsBtnOutlet.setTitleColor(.white, for: .normal)
//
//        captureActionView.layer.borderWidth = 20.0
//        captureActionView.layer.borderColor = UIColor.white.cgColor
//        captureActionView.backgroundColor = UIColor.clear
//
//    }
//
//    @IBAction func customCameraControlsAction(_ sender: Any) {
//        tag = (sender as AnyObject).tag!
//        switch tag {
//        case 0:
//            //WhiteBalance
//            print(tag)
//            let whiteBalanceGains = captureDevice?.deviceWhiteBalanceGains ?? AVCaptureDevice.WhiteBalanceGains()
//            let whiteBalanceTemperatureAndTint = captureDevice?.temperatureAndTintValues(for: whiteBalanceGains) ?? AVCaptureDevice.WhiteBalanceTemperatureAndTintValues()
//
//            self.sliderOutlet.minimumValue = 3000
//            self.sliderOutlet.maximumValue = 8000
//            self.sliderOutlet.value = whiteBalanceTemperatureAndTint.temperature
//
//            whiteBalanceCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "WhiteBalanceSelected"), for: .normal)
//            ISOControlActionOutlet.setImage(#imageLiteral(resourceName: "ISOUnselected"), for: .normal)
//            focusCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "FocusUnselected"), for: .normal)
//            exposureCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "ShutterSpeedUnSelected"), for: .normal)
//
//        case 1:
//            //Focus
//            print(tag)
//            self.sliderOutlet.minimumValue = 0
//            self.sliderOutlet.maximumValue = 1.0
//            self.sliderOutlet.value = 0.5
//
//            whiteBalanceCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "WhiteBalanceUnselected"), for: .normal)
//            ISOControlActionOutlet.setImage(#imageLiteral(resourceName: "ISOUnselected"), for: .normal)
//            focusCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "FocusSelected"), for: .normal)
//            exposureCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "ShutterSpeedUnSelected"), for: .normal)
//
//        case 2:
//            //ISO
//            print(tag)
//            self.sliderOutlet.minimumValue = 0
//            self.sliderOutlet.maximumValue = 1.0
//            self.sliderOutlet.value = 0.5
//
//            whiteBalanceCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "WhiteBalanceUnselected"), for: .normal)
//            ISOControlActionOutlet.setImage(#imageLiteral(resourceName: "ISOSelected"), for: .normal)
//            focusCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "FocusUnselected"), for: .normal)
//            exposureCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "ShutterSpeedUnSelected"), for: .normal)
//
//        case 3:
//            //Exposure
//            print(tag)
//            self.sliderOutlet.minimumValue = 3
//            self.sliderOutlet.maximumValue = 1012
//            self.sliderOutlet.value = 50
//
//            whiteBalanceCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "WhiteBalanceUnselected"), for: .normal)
//            ISOControlActionOutlet.setImage(#imageLiteral(resourceName: "ISOUnselected"), for: .normal)
//            focusCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "FocusUnselected"), for: .normal)
//            exposureCameraControlActionOutlet.setImage(#imageLiteral(resourceName: "ShutterSpeedSelected"), for: .normal)
//
//        default:
//            print("nill")
//        }
//    }
//
//    @IBAction func sliderAction(_ sender: UISlider) {
//
//        switch tag {
//        case 0:
//            //WhiteBalance
//            print(tag)
//            let temperatureAndTint = AVCaptureDevice.WhiteBalanceTemperatureAndTintValues(
//                temperature: self.sliderOutlet.value, tint: 17
//            )
//            self.setWhiteBalanceGains(captureDevice!.deviceWhiteBalanceGains(for: temperatureAndTint))
//        case 1:
//            //Focus
//            print(tag)
//            focusTo(value: sender.value)
//        case 2:
//            //ISO
//            print(tag)
//            updateDeviceSettings(focusValue: 1, isoValue:sender.value)
//        case 3:
//            //Exposure
//            print(tag)
//            updateDeviceDuration(focusValue: 1, isoValue: 0.5, exposure: sender.value)
//        default:
//            print("nil")
//        }
//
//        sliderValueLabel.text = String(sliderOutlet.value.rounded())
//        print(sliderOutlet.value.rounded())
//    }
//}

//
//  NormalCameraViewController.swift
//  24
//
//  Created by sri on 28/12/17.
//  Copyright © 2017 sri. All rights reserved.
//



import UIKit
import AVFoundation
import Photos
import SwiftyCam
import DropDown
import NVActivityIndicatorView


class NormalCameraViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var captureActionView: UIView!
    
    //@IBOutlet weak var camView: UIView!
    
    @IBOutlet weak var cameraControlsViewOutlet: UIView!
    
    @IBOutlet weak var ISOControlActionOutlet: UIButton!
    @IBOutlet weak var focusCameraControlActionOutlet: UIButton!
    @IBOutlet weak var exposureCameraControlActionOutlet: UIButton!
    @IBOutlet weak var whiteBalanceCameraControlActionOutlet: UIButton!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    @IBOutlet weak var momentLabel: UILabel!
    @IBOutlet weak var openMomentsListBtnOutlet: UIButton!
    
    @IBOutlet weak var openPhotoCaptureBtnOutlet: UIButton!
    @IBOutlet weak var openVideoCaptureBtnOutlet: UIButton!
    @IBOutlet weak var openCustomControlsBtnOutlet: UIButton!
    
    @IBOutlet weak var toogleCaptureViewOutlet: UIView!
    @IBOutlet weak var tooglecaptureBarViewOutlet: UIView!
    
    @IBOutlet weak var swtichCameraBtnOutlet: UIButton!
    @IBOutlet weak var flashBtnOutlet: UIButton!
    @IBOutlet weak var galleryBtnOutlet: UIButton!
    
    @IBOutlet weak var buildingView: UIView!
    
    @IBOutlet weak var backBtnOutlet: UIButton!
    
    @IBOutlet weak var newMomentView: UIView!
    @IBOutlet weak var newMomentLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var newMomentTextField: UITextField!
    @IBOutlet weak var addMomentBtn: UIButton!
    
    
    lazy var focusView:UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        view.backgroundColor = .clear
        view.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    
    var seconds = 0
    var timer = Timer()
    
    var capturedImage = UIImage()
    
    var cameraType: Int?
    var isRecordingVideo: Bool = true
    var isFlashOn: Bool = true
    
    var tag = Int()
    
    var videoRecordedUrl : URL!
    var videoRecordedData: Data?
    
    var dropDown = DropDown()
    var momentsNameArray : [String] = []
    var momentsIdArray: [String] = []
    var momentList: [UserMoments] = []
    var momentId: Int!
    
    var errorMessage: String!
    
    var isVideoIntrupted: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*****************NormalCameraViewController*****************")
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        cameraDelegate = self
        
        defaultCamera = .rear
        maximumVideoDuration = 300.0
        doubleTapCameraSwitch = false
        tapToFocus = true
        swipeToZoom = true
        
        cameraControlsViewOutlet.isHidden = true
        sliderValueLabel.isHidden = true
        sliderOutlet.isHidden = true
        momentLabel.isHidden = false
        
        swtichCameraBtnOutlet.isHidden = false
        flashBtnOutlet.isHidden = false
        
        buildingView.isHidden = true
        backBtnOutlet.isHidden = false
        momentLabel.isHidden = false
        
        captureActionView.layer.borderWidth = 20.0
        captureActionView.layer.borderColor = UIColor.white.cgColor
        captureActionView.backgroundColor = UIColor.clear
        
        cameraType = 0
        
        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        buildingView.frame = CGRect(x: (screenSize.width / 2) - 125 , y: (screenSize.height / 2) - 75, width: 250, height: 150)
        
        capturePhotoBtnStyle()
        capturePhotoBtnAllignment()
        toogleCaptureViewAllignment()
        cameraBtnsAllignments()
        newMomentAllignment()
        userMomentsRequest()
        
        dropDownMenu()
        
        tapGestures()
        sliderStyle()
        
        self.hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
 
    func tapGestures(){
        
        let capturePhotoTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(capturePhoto))
        captureActionView.isUserInteractionEnabled = true
        captureActionView.addGestureRecognizer(capturePhotoTapGestureRecognizer)
        
        let focusTap = UITapGestureRecognizer.init(target: self, action: #selector(handleFocus(tap:)))
        self.view.addGestureRecognizer(focusTap)
    }
    
    
    
    @objc func handleFocus (tap:UITapGestureRecognizer) {
       print("handleFocus")
    }
    
    func sliderStyle(){
        
        sliderOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        
    }

    @objc func capturePhoto(){
        
        if cameraType == 0{
            
            takePhoto()
            print("photo")
            
        } else if cameraType == 1{
            
           if isRecordingVideo == true {
                startVideoRecording()
            
            sliderValueLabel.isHidden = false
            
                print("start")
            isRecordingVideo = false
            } else {
            sliderValueLabel.isHidden = true
                stopVideoRecording()
                print("stop")
            isRecordingVideo = true
            }
            
        } else if cameraType == 2{
            
            
            
        }
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        capturedImage = photo
        
        performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
        print("captured Photo")
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
        print("videoRecordingStarted")
        runTimer()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
        
        stopVideoRecordAnimating()
        
        print("finishedVideoRecording")
        seconds = 0
        timer.invalidate()
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        guard let video = try? NSData(contentsOf: url, options: .mappedIfSafe) else {return}
        videoRecordedData = video as Data
        videoRecordedUrl = url
        print("url : \(url)")
        
        performSegue(withIdentifier: "PreviewVideoSegue", sender: nil)
    }
    
    func startVideoRecordAnimating(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowUserInteraction], animations: { () -> Void in
            self.captureActionView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }, completion: nil)
    }
    
    func stopVideoRecordAnimating(){
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: { () -> Void in
            self.captureActionView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        captureActionView.layer.removeAllAnimations()
    }
    
    
    func runTimer() {
        startVideoRecordAnimating()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        print("\(timeString(time: TimeInterval(seconds)))")
        sliderValueLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        // let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    func userMomentsRequest(){
        
        if self.momentsNameArray.count != 0 && self.momentsIdArray.count != 0 && self.momentList.count != 0{
            self.momentsNameArray.removeAll()
            self.momentsIdArray.removeAll()
            self.momentList.removeAll()
        }
        let parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/user_albums") { (isSucess, message, data) in
            if isSucess {
                if let responseArray = data["data"] as? [[String:Any]] {
                    print(responseArray)
                    
                    for dict in responseArray {
                        let momentsData = UserMoments(dict: dict)
                        self.momentList.append(momentsData)
                        self.momentsNameArray.append(momentsData.momentName!)
                        self.momentsIdArray.append(String(momentsData.momentId!))
                        print(self.momentList)
                    }
                    self.momentsNameArray.insert("Add", at: self.momentList.count)
                    self.dropDownMenu()
                }
            }else {
                print(message)
            }
        }
    }
    
    func dropDownMenu(){
        
        dropDown.anchorView = momentLabel
        dropDown.dataSource = momentsNameArray
        dropDown.direction = .any
        dropDown.width = 200
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == self.momentList.count {
                
                self.newMomentTextField.becomeFirstResponder()
                self.addMomentBtn.setTitle("Add", for: UIControlState.normal)
                print("addMoment")
            } else if index != self.momentList.count{
            print("Selected item: \(item) at index: \(index)")
            print("moment id is - \(self.momentsIdArray[index])")
            
            self.momentId = Int(self.momentsIdArray[index])
            self.momentLabel.text = item
            }
        }
        
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 20)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.groupTableViewBackground
        DropDown.appearance().cellHeight = 60
        
    }
    
    
    func createMoment(){
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 55, y: 0, width: 50, height: 50), type: .ballClipRotateMultiple, color: UIColor.white, padding: 0)
        addMomentBtn.setTitle("", for: UIControlState.normal)
        self.addMomentBtn.addSubview(activityIndicatorView)

        activityIndicatorView.startAnimating()

        let parameters = ["userid": mydetails!.userId, "signature": mydetails!.signature, "album_name": newMomentTextField.text] as [String : Any]
        
        AlamofireRequest.sharedInstance.alamofireRequest(dict: parameters, url: "https://api.my24space.com/v1/create_album") { (isSucess, message, data) in
            if isSucess {
                let albumId = data["album_id"] as? Int

                self.userMomentsRequest()
                activityIndicatorView.stopAnimating()
                self.newMomentTextField.resignFirstResponder()
                self.momentLabel.text = self.newMomentTextField.text!
                self.momentId = albumId
                self.newMomentTextField.text = ""
                self.errorMessage = "Sucess"
            }else {
                activityIndicatorView.stopAnimating()
                self.newMomentTextField.resignFirstResponder()
                self.errorMessage = "Error"
                self.performSegue(withIdentifier: "goToPopUpVc", sender: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PreviewPhotoSegue"{
            let previewVc = segue.destination as! PreviewCameraViewController
            previewVc.capturedImage = self.capturedImage
            previewVc.momentId = self.momentId
            previewVc.senderVC = self
        }
        
        if segue.identifier == "PreviewVideoSegue"{
            let previewVc = segue.destination as! PreviewVideoViewController
            previewVc.momentId = self.momentId
            previewVc.videoURL = videoRecordedUrl
            previewVc.videoData = videoRecordedData
            previewVc.senderVC = self
        }
        if segue.identifier == "goToPopUpVc"{
            let previewVc = segue.destination as! PopUpViewController
            previewVc.errorMessage = errorMessage
        }
    }
    

    @IBAction func switchCamera(_ sender: Any) {
        switchCamera()
        print("switch")
    }
    
    @IBAction func flashBtnAction(_ sender: Any) {
        
        if isFlashOn == true {
            flashEnabled = true
            print("start")
            flashBtnOutlet.setImage(#imageLiteral(resourceName: "FlashOnUnselected"), for: .normal)
            isFlashOn = false
        } else {
            flashEnabled = false
            print("stop")
            flashBtnOutlet.setImage(#imageLiteral(resourceName: "FlashOffUnselected"), for: .normal)
            isFlashOn = true
        }
    }
    @IBAction func openGalleryBtnAction(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
       // capturedImage.image = image
        capturedImage = image
        
        
        picker.dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
        })
        
//        dismiss(animated: false, completion: nil)
        
//        dismiss(animated: true, completion: {
//            performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
//        })
//        dismiss(animated: true, completion: ^{
//            performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
//            })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        print("tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openMomentsListBtnAction(_ sender: Any) {
        buildingView.isHidden = true
        momentLabel.isHidden = false
        cameraControlsViewOutlet.isHidden = true
        sliderOutlet.isHidden = true
        print("openGoTo")
        print(momentsNameArray.count)
        
        if momentsNameArray.count == 0{
            self.momentsNameArray.removeAll()
            self.momentsNameArray.insert("Add", at: 0)
            print(momentsNameArray)
            self.dropDownMenu()
            dropDown.show()
        }else {
            dropDown.show()
        }
    }
    
    @IBAction func openPhotoCaptureBtnAction(_ sender: Any) {
        
        buildingView.isHidden = true
        backBtnOutlet.isHidden = false
        momentLabel.isHidden = false
        
        openMomentsListBtnOutlet.isHidden = false
        flashBtnOutlet.isHidden = false
        swtichCameraBtnOutlet.isHidden = false
        
        cameraControlsViewOutlet.isHidden = true
        sliderValueLabel.isHidden = true
        sliderOutlet.isHidden = true
        swtichCameraBtnOutlet.isHidden = false
        flashBtnOutlet.isHidden = false
        
        cameraType = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
        }, completion: nil)
        
        stopVideoRecordAnimating()
        stopVideoRecording()
        isVideoIntrupted = true
        
        tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
        
        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        openPhotoCaptureBtnOutlet.setTitleColor(.white, for: .normal)
        openVideoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
        openCustomControlsBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
        
        captureActionView.layer.borderWidth = 20.0
        captureActionView.layer.borderColor = UIColor.white.cgColor
        captureActionView.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func openVideoCaptureBtnAction(_ sender: Any) {
        
        buildingView.isHidden = true
        backBtnOutlet.isHidden = false
        momentLabel.isHidden = false
        
        openMomentsListBtnOutlet.isHidden = false
        flashBtnOutlet.isHidden = false
        swtichCameraBtnOutlet.isHidden = false
        
        cameraControlsViewOutlet.isHidden = true
        sliderValueLabel.isHidden = false
        sliderOutlet.isHidden = true
        swtichCameraBtnOutlet.isHidden = false
        flashBtnOutlet.isHidden = false
        
        cameraType = 1
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tooglecaptureBarViewOutlet.frame = CGRect(x: self.openPhotoCaptureBtnOutlet.frame.width, y: 5, width: (screenSize.width / 3), height: 2)
        }, completion: nil)
        
        isVideoIntrupted = false
        
        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        
        openPhotoCaptureBtnOutlet.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
        openVideoCaptureBtnOutlet.setTitleColor(.white, for: .normal)
        openCustomControlsBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
        
        captureActionView.layer.borderWidth = 20.0
        captureActionView.layer.borderColor = UIColor.red.cgColor
        captureActionView.backgroundColor = UIColor.white
        
    }
    @IBAction func openCustomControlsBtnAction(_ sender: Any) {
        
        buildingView.isHidden = false
        backBtnOutlet.isHidden = true
        momentLabel.isHidden = true
        
        openMomentsListBtnOutlet.isHidden = true
        flashBtnOutlet.isHidden = true
        swtichCameraBtnOutlet.isHidden = true
        
        
      //  cameraControlsViewOutlet.isHidden = false
        sliderValueLabel.isHidden = true
//        sliderOutlet.isHidden = false
//        swtichCameraBtnOutlet.isHidden = true
//        flashBtnOutlet.isHidden = true
//
        cameraType = 2
        
        UIView.animate(withDuration: 0.2, animations: {
            self.tooglecaptureBarViewOutlet.frame = CGRect(x: (self.openPhotoCaptureBtnOutlet.frame.width * 2), y: 5, width: (screenSize.width / 3), height: 2)
        }, completion: nil)
        
        openPhotoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        openVideoCaptureBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        openCustomControlsBtnOutlet.titleLabel?.font = UIFont(name: "Montserrat-Medium", size: 18)
        
        openPhotoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
        openVideoCaptureBtnOutlet.setTitleColor(.groupTableViewBackground, for: .normal)
        openCustomControlsBtnOutlet.setTitleColor(.white, for: .normal)
        
        captureActionView.layer.borderWidth = 20.0
        captureActionView.layer.borderColor = UIColor.white.cgColor
        captureActionView.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func addMomentBtnAction(_ sender: Any) {
        
        if newMomentTextField.text != ""{
          createMoment()
        }else {
            CustomNotification.sharedInstance.notificationBanner(message: "Please enter Moment name.", style: .danger)
         print("empty")
        }
    }
    
    @IBAction func customCameraControlsAction(_ sender: Any) {
        
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        print(point)
        self.view.addSubview(focusView)
        focusView.center = point
        focusView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.66, delay: 0.1, usingSpringWithDamping: 0.66, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: {
            self.focusView.transform = .identity
        }) { (isCompleted) in
            self.dismissFocusView()
        }
    }
    
    @objc func dismissFocusView() {
        focusView.removeFromSuperview()
    }
    
}

extension NormalCameraViewController {
    
    func capturePhotoBtnStyle(){
        
        captureActionView.layer.borderWidth = 20.0
        captureActionView.layer.borderColor = UIColor.white.cgColor
    }

    func capturePhotoBtnAllignment(){
        
        captureActionView.frame = CGRect(x: (screenSize.width / 2) - 35, y: screenSize.height - 135, width: 70, height: 70)
        
    }
    
    func toogleCaptureViewAllignment(){
        
        toogleCaptureViewOutlet.frame = CGRect(x: 0, y: (screenSize.height - 50), width: screenSize.width, height: 50)
        tooglecaptureBarViewOutlet.frame = CGRect(x: 0, y: 5, width: (screenSize.width / 3), height: 2)
        openPhotoCaptureBtnOutlet.frame = CGRect(x: 0, y: 10, width: (screenSize.width / 3), height: 40)
        openVideoCaptureBtnOutlet.frame = CGRect(x: openPhotoCaptureBtnOutlet.frame.width, y: 10, width: (screenSize.width / 3), height: 40)
        openCustomControlsBtnOutlet.frame = CGRect(x: (openVideoCaptureBtnOutlet.frame.width * 2), y: 10, width: (screenSize.width / 3), height: 40)
        
    }
    
    func cameraBtnsAllignments(){
        
        swtichCameraBtnOutlet.frame = CGRect(x: ((screenSize.width / 2) - 115) / 3, y: (screenSize.height - 120), width: 40, height: 40)
        flashBtnOutlet.frame = CGRect(x: swtichCameraBtnOutlet.frame.origin.x + 40 + (((screenSize.width / 2) - 115) / 3), y: (screenSize.height - 120), width: 40, height: 40)
        
        let xpadding = (((screenSize.width - (captureActionView.frame.origin.x + 70)) - 60) / 3)
        let frame = CGRect(x: (captureActionView.frame.origin.x + 70) + xpadding , y: (screenSize.height - 116), width: 30, height: 30)
        openMomentsListBtnOutlet.frame = frame
        galleryBtnOutlet.frame = CGRect(x: screenSize.width - 60, y: (screenSize.height - 116), width: 30, height: 30)
        

       // backBtnOutlet.frame = CGRect(x: 0, y: 15, width: 50, height: 50)
       // momentLabel.frame = CGRect(x: (screenSize.width / 2) - 75, y: 25, width: 150, height: 30)
        
        sliderValueLabel.frame = CGRect(x: screenSize.width - 55, y: 25, width: 50, height: 30)
        
    }
    func newMomentAllignment(){
        
        newMomentView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        newMomentLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 50)
        seperatorView.frame = CGRect(x: 0, y: 50, width: screenSize.width, height: 1)
        newMomentTextField.frame = CGRect(x: 20, y: 75, width: screenSize.width - 40, height: 30)
        addMomentBtn.frame = CGRect(x: (screenSize.width / 2) - 75, y: 130, width: 150, height: 40)

    }
}

extension NormalCameraViewController{
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        
        UIView.animate(withDuration: 1) {
        self.newMomentView.frame = CGRect(x: 0, y: screenSize.height - (keyboardHeight + 180), width: screenSize.width, height: 180)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        
        UIView.animate(withDuration: 1) {
                self.newMomentView.frame = CGRect(x: 0, y: 800, width: screenSize.width, height: 180)
        }
    }
}
