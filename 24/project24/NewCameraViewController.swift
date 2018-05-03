//
//  NewCameraViewController.swift
//  project24
//
//  Created by sri on 25/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class NewCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var captureSession = AVCaptureSession()
    
    var backCamera : AVCaptureDevice?
    var frontCamera : AVCaptureDevice?
    var currentCamera : AVCaptureDevice?
    
    var photoOutput : AVCapturePhotoOutput?
    
    var cameraPreviewlayer : AVCaptureVideoPreviewLayer?
    
    var capturedImage : UIImage?
    
    var videoUrl : NSURL?
    
    var folderImageSelected : Bool?


    @IBOutlet weak var folderImageView: UIImageView!
    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var camerarollButtonOutlet: UIButton!
    //@IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var frontCameraOutlet: UIButton!
    @IBOutlet weak var captureButtonOutlet: UIButton!
    
    @IBOutlet weak var createFolderViewOutlet: UIButton!
    @IBOutlet weak var createFolderView: UIView!
    @IBOutlet weak var createFolderImageView: UIImageView!
    @IBOutlet weak var createFolderName: UITextField!
    @IBOutlet weak var createFolderOutlet: UIButton!
    @IBOutlet weak var skipOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        folderImageViewTapped()
        
        createFolderView.isHidden = true
        
        folderImageSelected = false
    }
    
    func folderImageViewTapped(){
    
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(folderSelectImage))
        createFolderImageView.addGestureRecognizer(tapGesture)
        createFolderImageView.isUserInteractionEnabled = true
        
    }

    func folderSelectImage(){
        
        let photo = UIImagePickerController()
        photo.mediaTypes = [kUTTypeImage as String,]
        photo.allowsEditing = true
        photo.delegate = self
        self.present(photo, animated: true, completion: nil)
        folderImageSelected = true
    }
    
    // Image Quality and resolution
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
    }
    // To represent which type of camera device
    func setupDevice(){
        
        let deviceDiscoverySession  = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        let devices = deviceDiscoverySession?.devices
        
        for device in devices! {
            if device.position == AVCaptureDevicePosition.back {
                backCamera = device
            }else if device.position == AVCaptureDevicePosition.front {
                frontCamera = device
            }
            currentCamera = backCamera
        }
    }
    
    // Takes capture devices and connect to capture session
    func setupInputOutput(){
        
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
            captureSession.addOutput(photoOutput)
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    // To display camera opn the screen
    func setupPreviewLayer(){
        cameraPreviewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewlayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewlayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewlayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewlayer!, at: 0)
    }
    
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        
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



    @IBAction func backButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func camerarollButtonAction(_ sender: Any) {
        
        
        selectImage()
        
        
    }
    
    func selectImage(){
        
        let photo = UIImagePickerController()
        photo.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        photo.allowsEditing = true
        photo.delegate = self
        self.present(photo, animated: true, completion: nil)
    }
    

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if folderImageSelected == true {
            
            dismiss(animated: true, completion: { () -> Void in
                
                
                if let image = info["UIImagePickerControllerEditedImage"] as? UIImage{
                    self.createFolderImageView.image = image
                    self.folderImageView.image  = self.createFolderImageView.image
                     self.folderImageSelected = false
                }
               
            })

        
        }else{
        
            if let videooUrl = info[UIImagePickerControllerMediaURL] as? NSURL {
                videoUrl = videooUrl
            } else if let image = info["UIImagePickerControllerEditedImage"] as? UIImage{
                capturedImage = image
            }
            dismiss(animated: true, completion: { () -> Void in
                //Will call segue name
                self.performSegue(withIdentifier: "PreviewPhotoSegue", sender: nil)
            })
        }
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PreviewPhotoSegue"{
            
            let previewVc = segue.destination as! NewPreviewViewController
            previewVc.image = self.capturedImage
            previewVc.previewVideoUrl = self.videoUrl
            previewVc.previewFolderImage = self.folderImageView.image
            previewVc.previewFolderName = self.folderNameLabel.text
            
        }
    }
    
    
    @IBAction func frontCameraButton(_ sender: Any) {
        
        
    }
    @IBAction func cameraButtonAction(_ sender: Any) {
        
                photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
    }
    
    @IBAction func createFolderViewAction(_ sender: Any) {
        createFolderView.isHidden = false
    }
    
    @IBAction func createFolderAction(_ sender: Any) {
    createFolderView.isHidden = true
    folderImageView.image = createFolderImageView.image
    folderNameLabel.text = createFolderName.text
    }
    
    @IBAction func skipAction(_ sender: Any) {
        createFolderView.isHidden = true
    }
    

}
