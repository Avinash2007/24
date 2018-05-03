//
//  NewOnBoardCameraViewController.swift
//  project24
//
//  Created by sri on 27/09/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import ProgressHUD

class NewOnBoardCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet weak var textIconTapped: UIImageView!
    @IBOutlet weak var textImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var swiped = false
    var isDrawing = true
    
    var red:Float = 0.0
    var green:Float = 0.0
    var blue:Float = 0.0
    
    var pickedImage : UIImage!
    
    var fontCounter : CGFloat!
    
    var maxCharacter: Int = 35
    
    var textViewDidTap : Bool!

    
 //   var textView = UITextView()
    
   // var scrollVieww = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textIconImageViewTapped()

        fontCounter = 41
        
        textViewDidTap = false
        

        // Do any additional setup after loading the view.
    }
    
    func textIconImageViewTapped(){
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(writeText))
        textIconTapped.addGestureRecognizer(tapGesture)
        textIconTapped.isUserInteractionEnabled = true
        
    }
    
    
    
    func writeText(){
        
        if textViewDidTap == false{
        textViewDidTap = true
            let textView = UITextView(frame: CGRect(x: 20, y: self.textImageView.frame.size.height / 2, width: 335, height: 300))
            textView.delegate = self
            textView.textAlignment = NSTextAlignment.center
            
            // textView.center = imageView.center
            textView.font = UIFont(name: "helvetica", size: self.fontCounter)
            textView.text = "sample text"
            textView.textColor = UIColor.red
            textView.isUserInteractionEnabled = true
            textView.backgroundColor = UIColor.clear
            
            self.view.addSubview(textView)
            
            print("write some text")
            
        }

        
    }
    
    
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length >= 214 {
            return false
            //textView.text = String(textView.text.characters.dropLast())
        }
        
        if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length >= maxCharacter
        {
            if self.fontCounter > 17 {
                self.fontCounter = self.fontCounter - 8;
                maxCharacter = maxCharacter + 30;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
            }
            
        }
        else
        {
            
            if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 35
            {
                self.fontCounter = 41;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 65
            {
                
                self.fontCounter = 37;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
            else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 100
            {
                
                self.fontCounter = 33;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
            else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 135
            {
                
                self.fontCounter = 29;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
            else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 170
            {
                
                self.fontCounter = 25;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
            else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 205
            {
                
                self.fontCounter = 21;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
            else if (textView.text?.utf16.count ?? 0) + text.utf16.count - range.length <= 240
            {
                
                self.fontCounter = 17;
                textView.font = UIFont(name: "helvetica", size: CGFloat(self.fontCounter))
                
            }
        }
        return true
        
        
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        if let touch = touches.first{
            //
            lastPoint = touch.location(in: self.viewImage)
        }
    }
    func drawLines(fromPoint: CGPoint , toPoint: CGPoint){
        
        UIGraphicsBeginImageContext(self.viewImage.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.viewImage.frame.width, height: self.viewImage.frame.height))
        var context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first{
            
            var currentPoint = touch.location(in: self.viewImage)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
            
        }
        
        func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if !swiped {
                
                drawLines(fromPoint: lastPoint, toPoint: lastPoint)
                
            }
        }
    }
    
    @IBAction func eraser(_ sender: Any) {

        self.imageView.image = nil
    }
    
    func captureScreen() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(viewImage.bounds.size, false, UIScreen.main.scale)
        viewImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func currentDate() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func convertNextDate(dateString : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        return somedateString
    }
    
    @IBAction func sendButton(_ sender: Any) {
        print("uploading")
        ProgressHUD.show("waiting...")
        if let image = captureScreen() {
            
            
            OnBoardFirebaseService.sharedInstance.onBoard(onBoardImage: image, onBoardDetails: ["currentDate" : currentDate(),"deleteDate" : convertNextDate(dateString: currentDate())], completionBlock: { (snapshot) in
                ProgressHUD.showSuccess()
                self.imageView.image = nil
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            ProgressHUD.showError("Shout can't be empty")
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if let image = captureScreen() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    @IBAction func colorPicked(_ sender: Any) {
        
        switch (sender as AnyObject).tag {
        case 0:
            (red,green,blue) = (1,1,1)
            print("0")
        case 1:
            (red,green,blue) = (0,1,0)
        case 2:
            (red,green,blue) = (1,1,0)
        case 3:
            (red,green,blue) = (255,39,0)
        case 4:
            (red,green,blue) = (112,112,112)
        case 5:
            (red,green,blue) = (255,137,1)
        case 6:
            (red,green,blue) = (253,94,189)
        case 7:
            (red,green,blue) = (157,0,255)
        case 8:
            (red,green,blue) = (175,87,0)
        case 9:
            (red,green,blue) = (231,81,119)
        case 10:
            (red,green,blue) = (228,187,71)
        case 11:
            (red,green,blue) = (148,22,81)
        case 12:
            (red,green,blue) = (97,49,2)
        case 13:
            (red,green,blue) = (110,166,190)
        default:
            (red,green,blue) = (0,0,0)
        }
        
    } 

    
   /* @IBAction func backgroungBtn(_ sender: Any) {
        
        backgroundChangeView.isHidden = false
        colorChangeView.isHidden = true
        
    }
    @IBAction func colorBtn(_ sender: Any) {
        
        backgroundChangeView.isHidden = true
        colorChangeView.isHidden = false
    } */

}
