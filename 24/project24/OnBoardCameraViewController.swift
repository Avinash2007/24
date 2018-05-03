////
////  ViewController.swift
////  drawingApplication
////
////  Created by sri on 04/09/17.
////  Copyright © 2017 sri. All rights reserved.
////
//
//import UIKit
//import ProgressHUD
//
//class OnBoardCameraViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
//
//   // @IBOutlet var imageView: UIImageView!
////    @IBOutlet var viewImage: UIView!
//    
//    @IBOutlet weak var colorChangeView: UIView!
//    @IBOutlet weak var backgroundChangeView: UIView!
////    var lastPoint = CGPoint.zero
////    var swiped = false
////    var isDrawing = true
////    
////    var red:Float = 0.0
////    var green:Float = 0.0
////    var blue:Float = 0.0
//    
//    var pickedImage : UIImage!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        swiped = false
//        if let touch = touches.first{
//            //
//            lastPoint = touch.location(in: self.viewImage)
//        }
//    }
//    func drawLines(fromPoint: CGPoint , toPoint: CGPoint){
//        
//        UIGraphicsBeginImageContext(self.viewImage.frame.size)
//        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.viewImage.frame.width, height: self.viewImage.frame.height))
//        var context = UIGraphicsGetCurrentContext()
//        
//        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
//        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
//        
//        context?.setBlendMode(CGBlendMode.normal)
//        context?.setLineCap(CGLineCap.round)
//        context?.setLineWidth(5)
//        context?.setStrokeColor(UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).cgColor)
//        
//        context?.strokePath()
//        
//        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        
//    }
////
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = true
//        if let touch = touches.first{
//            
//            var currentPoint = touch.location(in: self.viewImage)
//            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
//            
//            lastPoint = currentPoint
//            
//        }
//        
//        func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            
//            if !swiped {
//                
//                drawLines(fromPoint: lastPoint, toPoint: lastPoint)
//                
//            }
//        }
//    }
//    @IBAction func setings(_ sender: Any) {
//        
//        let camera = UIImagePickerController()
//        camera.sourceType = .photoLibrary
//        camera.allowsEditing = true
//        camera.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
//        self.present(camera, animated: true, completion: nil)
//        
//    }
////    @IBAction func eraser(_ sender: Any) {
////        if (isDrawing) {
////            (red,green,blue) = (1,1,1)
////        }else {
////            (red,green,blue) = (0,0,0)
////            
////        }
////    }
//    
//    
////    @IBAction func save(_ sender: Any) {
////        if let image = imageView.image {
////            let image1 = captureScreen()
////            performSegue(withIdentifier: "showOnBoardPhotoSegue", sender: nil)
////            UIImageWriteToSavedPhotosAlbum(image1!, nil, nil, nil)
////        }
////    }
//    
//    
////    @IBAction func save(_ sender: Any) {
////        
////        if let image = imageView.image {
////            performSegue(withIdentifier: "showOnBoardPhotoSegue", sender: nil)
////            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
////        }
////    }
//    
//    func captureScreen() -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(viewImage.bounds.size, false, UIScreen.main.scale)
//        viewImage.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//    
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        
////        if segue.identifier == "showOnBoardPhotoSegue"{
////
////                let previewVc = segue.destination as! OnBoardPreviewCameraViewController
////            //previewVc.onBoardImage = imageView.image
////                previewVc.onBoardImage = captureScreen()
////        }
////    }
//   
////    @IBAction func reset(_ sender: Any) {
////        self.imageView.image = nil
////    }
//    
///*    @IBAction func colorPicked(_ sender: Any) {
//        
//        switch (sender as AnyObject).tag {
//        case 0:
//            (red,green,blue) = (36,141,211)
//        case 1:
//            (red,green,blue) = (0,200,0)
//        case 2:
//            (red,green,blue) = (254,191,2)
//        case 3:
//            (red,green,blue) = (255,39,0)
//        case 4:
//            (red,green,blue) = (112,112,112)
//        case 5:
//            (red,green,blue) = (255,137,1)
//        case 6:
//            (red,green,blue) = (253,94,189)
//        case 7:
//            (red,green,blue) = (157,0,255)
//        case 8:
//            (red,green,blue) = (175,87,0)
//        case 9:
//            (red,green,blue) = (231,81,119)
//        case 10:
//            (red,green,blue) = (228,187,71)
//        case 11:
//            (red,green,blue) = (148,22,81)
//        case 12:
//            (red,green,blue) = (97,49,2)
//        case 13:
//            (red,green,blue) = (110,166,190)
//        default:
//            (red,green,blue) = (0,0,0)
//        }
//        
//    } */
//    
////    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
////    
////        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
////    
////            self.imageView.image = pickedImage
////            self.dismiss(animated: true, completion: nil)
////        }
////    }
//   
//   /* @IBAction func pickImageColour(_ sender: Any) {
//        
//        switch (sender as AnyObject).tag {
//        case 0:
//            imageView.backgroundColor = UIColor(red: 36, green: 141, blue: 211, alpha: 1)
//        case 1:
//            imageView.backgroundColor = UIColor(red: 0, green: 200, blue: 0, alpha: 1)
//        case 2:
//            imageView.backgroundColor = UIColor(red: 254, green: 191, blue: 2, alpha: 1)
//        case 3:
//            imageView.backgroundColor = UIColor(red: 255, green: 39, blue: 0, alpha: 1)
//        case 4:
//            imageView.backgroundColor = UIColor(red: 112, green: 112, blue: 112, alpha: 1)
//        case 5:
//            imageView.backgroundColor = UIColor(red: 255, green: 137, blue: 1, alpha: 1)
//        case 6:
//            imageView.backgroundColor = UIColor(red: 253, green: 94, blue: 189, alpha: 1)
//        case 7:
//            imageView.backgroundColor = UIColor(red: 157, green: 0, blue: 255, alpha: 1)
//        case 8:
//            imageView.backgroundColor = UIColor(red: 175, green: 87, blue: 0, alpha: 1)
//        case 9:
//            imageView.backgroundColor = UIColor(red: 231, green: 81, blue: 119, alpha: 1)
//        case 10:
//            imageView.backgroundColor = UIColor(red: 228, green: 187, blue: 71, alpha: 1)
//        case 11:
//            imageView.backgroundColor = UIColor(red: 148, green: 22, blue: 81, alpha: 1)
//        case 12:
//            imageView.backgroundColor = UIColor(red: 97, green: 49, blue: 2, alpha: 1)
//        case 13:
//            imageView.backgroundColor = UIColor(red: 110, green: 166, blue: 190, alpha: 1)
//        default:
//            imageView.backgroundColor = .white
//        }
//    } */
////    @IBAction func backgroungBtn(_ sender: Any) {
////        
////        backgroundChangeView.isHidden = false
////        colorChangeView.isHidden = true
////        
////    }
////    @IBAction func colorBtn(_ sender: Any) {
////        
////        backgroundChangeView.isHidden = true
////        colorChangeView.isHidden = false
////        
////    }
//    
////    @IBAction func backBtn(_ sender: Any) {
////        
////        self.dismiss(animated: true, completion: nil)
////        
////    }
//    
//}
