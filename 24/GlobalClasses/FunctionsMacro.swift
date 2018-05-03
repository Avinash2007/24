//
//  Macro.swift
//  VideoChat


import Foundation
import UIKit

import Photos
import AssetsLibrary
import HealthKit
import UserNotifications
import AVFoundation
import SDWebImage


let documentsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
var downloadURL = try! FileManager().url(for: .documentDirectory,
                                         in: .userDomainMask,
                                         appropriateFor: nil,
                                         create: true)

let window = UIApplication.shared.keyWindow

let defaults = UserDefaults.standard
let rupee = "₹"

let borderWidth : CGFloat = 1.0
let borderColor  : UIColor =  #colorLiteral(red: 0.06274509804, green: 0.5411764706, blue: 0.6941176471, alpha: 1)
let cornerRadius : CGFloat = 4.0
let date = NSDate()
var isAuthrized:HKAuthorizationStatus!
let dateFormatter = DateFormatter()


enum PackType : String{
    case text
    case phone
    case video
}
enum Consultation {
    case selfConsultation
    case familyConsultation
}



func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
    guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
        completion(false)
        return
    }
    guard #available(iOS 10, *) else {
        completion(UIApplication.shared.openURL(url))
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: completion)
}

enum FileType:Int{
    case ImageType = 0
    case FileType = 1
}

var tableFooterView:UIView = {
    let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
    view.backgroundColor = .clear
    let activity = UIActivityIndicatorView.init(frame: CGRect.init(x: SCREEN_WIDTH/2 - 20, y: 5, width: 40, height: 40))
    activity.color = themeColor
    activity.center = view.center
    activity.startAnimating()
    view.addSubview(activity)
    return view
}()

enum FontStyle{
    case Regular
    case SemiBold
    case Bold
    case Medium
    case Light
}

func heightForView(_ text: Any, font:UIFont, width:CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    return estimatedFrame.size.height
}



func widthForView(_ text: Any, font:UIFont, width:CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font], context: nil)
    return estimatedFrame.size.width
}



func applyShadowForView(_ view :UIView) {
    view.layer.shadowColor = seperatorColor.cgColor
    view.layer.shadowOffset = CGSize(width: 0 , height: 10);
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = 5.0
    view.layer.masksToBounds = false
}

func applyShadowonEveryWall(_ view :UIView) {
    view.layer.shadowColor = seperatorColor.cgColor
    view.layer.shadowOffset = CGSize(width: 8 , height: 8);
    view.layer.shadowOpacity = 1.0
    view.layer.shadowRadius = 8.0
    view.layer.masksToBounds = false
}

func applyShadow(view:UIView , radius:CGFloat) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 1.5
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

func addRoundedLightLayer(radius:CGFloat , view :UIView?) {
    view?.clipsToBounds = false
    view?.layer.shadowColor = UIColor.lightGray.cgColor
    view?.layer.shadowOpacity = 0.56
    view?.layer.shadowOffset = CGSize.zero
    view?.layer.shadowRadius = 2.6
    view?.layer.cornerRadius = radius
}


func addTabBarShadow(radius:CGFloat , view :UIView?) {
    view?.clipsToBounds = false
    view?.layer.shadowColor = UIColor.lightGray.cgColor
    view?.layer.shadowOpacity = 0.489
    view?.layer.shadowOffset = CGSize.zero
    view?.layer.shadowRadius = 4.0
    view?.layer.cornerRadius = radius
}


func getFileType(_ url:String)->(Int? , String?){
    if let fileURL = URL.init(string: url){
        print("File Type----->>>>>>",fileURL,"\n\n\n\n")
        let array:[String]? = fileURL.lastPathComponent.components(separatedBy: ".")
        print("File Components----->>>>>>",array ?? "NIL","\n\n\n\n")
        if (array?.count)! > 1{
            if let type = array?[1]{
                if type == "JPG" || type == "jpg" || type == "PNG" || type == "png" || type == "JPEG" || type == "jpeg"{
                    return (FileType.ImageType.rawValue , fileURL.lastPathComponent)
                }else{
                    return (FileType.FileType.rawValue , fileURL.lastPathComponent)
                }
            }
        }
    }
    return (nil , nil)
}

func getFileType(_ url:URL)->(Int? , String?){
    print("File Type----->>>>>>",url,"\n\n\n\n")
    let array:[String]? = url.lastPathComponent.components(separatedBy: ".")
    print("File Components----->>>>>>",array ?? "NIL","\n\n\n\n")
    if let type = array?[1]{
        if type == "JPG" || type == "jpg" || type == "PNG" || type == "png" || type == "JPEG" || type == "jpeg"{
            return (FileType.ImageType.rawValue , url.lastPathComponent)
        }else{
            return (FileType.FileType.rawValue , url.lastPathComponent)
        }
    }
    return (nil , nil)
}

func getRectForImage(_ imageView:UIImageView)->CGRect?{
    let height = SCREEN_WIDTH * (imageView.frame.height) / (imageView.frame.width)
    return CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
}




func showAlert(msg:String , title:String , sender:UIViewController){
    let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
    let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
    alert.addAction(okAction)
    sender.present(alert, animated: true, completion: nil)
}


func drawLayerBelowView(_ view: UIView , color : UIColor) {
    let layer = CALayer()
    layer.frame = CGRect(x: CGFloat(0), y: CGFloat(view.frame.size.height - 1), width: CGFloat(view.frame.size.width), height: CGFloat(1.0))
    layer.backgroundColor = color.cgColor
    layer.name = "bottomLayer"
    view.layer.addSublayer(layer)
}

func setupGradientLayer(view:UIView , upperColor:UIColor, lowerColor:UIColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds
    print(view.bounds)
    gradientLayer.colors = [upperColor.cgColor, lowerColor.cgColor]
    gradientLayer.locations = [0.13,0.90]
    if view.layer.sublayers != nil{
        if (view.layer.sublayers?.count)! > 0{
            //print("Layer Count--->>>",(view.layer.sublayers?.count)!)
            for layer in view.layer.sublayers!{
                layer.removeFromSuperlayer()
            }
        }
    }
    view.layer.addSublayer(gradientLayer)
}


func setButtonBorder(button : UIButton , borderColor : UIColor , width : CGFloat = borderWidth){
    button.layer.borderWidth = width
    button.layer.borderColor = borderColor.cgColor
    button.layer.cornerRadius = cornerRadius
}

func getPoppinsFont(style:FontStyle , size:CGFloat)->UIFont?{
    switch style {
    case .Regular:
        return UIFont(name: "Poppins-Regular", size: size)
    case .Medium:
        return UIFont(name: "Poppins-Medium", size: size)
    case .SemiBold:
        return UIFont(name: "Poppins-SemiBold", size: size)
    case .Bold:
        return UIFont(name: "Poppins", size: size)
    case .Light:
        return UIFont(name: "Poppins-Light", size: size)
    }
}
let imageHeight = Int(0.61 * SCREEN_WIDTH)

func heightForViewForAttributedCondition(_ text: Any, fontSize:CGFloat, width:CGFloat,numberOfLines : Int,isAtrributedString : Bool) -> CGFloat{
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
    let font = getPoppinsFont(style: .Regular, size: fontSize)
    if isAtrributedString{
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = text as? NSAttributedString
        label.sizeToFit()
        return label.frame.height
    }else{
        let estimatedFrame = NSString(string: text as! String).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: font!], context: nil)
        return estimatedFrame.size.height
    }
}



func convertDate(fromFormat : String = "HH:mm:ss", toFormat : String = "h:mm a", time : String)->String?{
    
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    
    
    formatter.dateFormat = "HH:00:00"
    if let date = formatter.date(from: time){
        //print("date : \(date)")
        formatter.dateFormat = "h:mm a"
        
        let string = formatter.string(from: date)
        //print(string)
        return string
        
    }
    else {
        formatter.dateFormat = fromFormat
        
        if  let date = formatter.date(from: time) {
            //print("date : \(date)")
            
            formatter.dateFormat = toFormat
            
            let string = formatter.string(from: date)
            return string
        }
    }
    
    return nil
}



func getFileName(imageURL : URL, completionHandler : @escaping (String)->Void){
    var name : String?
    let assetslibrary = ALAssetsLibrary()
    assetslibrary.asset(for: imageURL, resultBlock: { (imageAsset) in
        if let imageRep = imageAsset?.defaultRepresentation(){
            name  = imageRep.filename()!
            completionHandler(name!.lowercased())
        }else{
            completionHandler("")
        }
        
    }, failureBlock: nil)
    
    
}


func havePhotoAccess(completionHandler: @escaping (Bool)->Void) {
    
    let status = PHPhotoLibrary.authorizationStatus()
    print(status)
    if (status == PHAuthorizationStatus.authorized) {
        // Access has been granted.
        print("photo access allowed")
        completionHandler(true)
        
    }
        
    else if (status == PHAuthorizationStatus.denied) {
        // Access has been denied.
        print("photo access denied")
        
        completionHandler(false)
    }
        
    else if (status == PHAuthorizationStatus.notDetermined) {
        
        // Access has not been determined.
        PHPhotoLibrary.requestAuthorization({ (newStatus) in
            
            if (newStatus == PHAuthorizationStatus.authorized) {
                completionHandler(true)
            }
                
            else {
                completionHandler(false)
            }
        })
    }
    
}

func haveCameraAccess(completionHandler: @escaping (Bool)->Void) {
    if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized
    {
        // Already Authorized
        print("camera permission already authorised")
        completionHandler(true)
    }
    else
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
            if granted == true
            {
                // User granted
                print("camera permission granted")
                completionHandler(true)
            }
            else
            {
                completionHandler(false)
                // User Rejected
                
            }
        });
    }
    
    
}


func getTimeStamp()-> Double{
    return Date().timeIntervalSince1970
}



func getWeekDay(date : Date)-> Int{
    let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    let myComponents = myCalendar.components(.weekday, from: date)
    if let weekDay = myComponents.weekday{
        return weekDay
    }
    return 0
}

func getDayName(date : Date)-> String{
    let weekday = getWeekDay(date: date)
    switch weekday {
    case 1:
        return "Sun"
    case 2:
        return "Mon"
    case 3:
        return "Tue"
    case 4:
        return "Wed"
    case 5:
        return "Thu"
    case 6:
        return "Fri"
    case 7:
        return "Sat"
    default:
        return ""
    }
}
func getDayNameShort(date : Date)-> String{
    let weekday = getWeekDay(date: date)
    switch weekday {
    case 1:
        return "SU"
    case 2:
        return "MO"
    case 3:
        return "TU"
    case 4:
        return "WE"
    case 5:
        return "TH"
    case 6:
        return "FR"
    case 7:
        return "ST"
    default:
        return ""
    }
}

extension Date{
    func dayName()->String{
        let weekday = getWeekDay(date: self)
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
}


func endNotificationDate(days : Int,date : Date)-> Date{
    let interval = TimeInterval(60 * 60 * 24 * days)
    let newDate = date.addingTimeInterval(interval)
    return newDate as Date
}
func removeNotification(){
    
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    } else {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
}


func getdateArryFromWeekdays(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]{
    var correctedDate: [Date] = [Date]()
    let now = Date()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
    let dateComponents = (calendar as NSCalendar).components(flags, from: date)
    let weekday:Int = dateComponents.weekday!
    
    //no repeat
    if weekdays.isEmpty{
        //scheduling date is eariler than current date
        if date < now {
            //plus one day, otherwise the notification will be fired righton
            correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchNextTime)!)
        }
        else { //later
            correctedDate.append(date)
        }
        return correctedDate
    }
        //repeat
    else {
        let daysInWeek = 7
        correctedDate.removeAll(keepingCapacity: true)
        for wd in weekdays {
            
            var wdDate: Date!
            //schedule on next week
            if compare(weekday: wd, with: weekday) == .before {
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
            }
            else { //after
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
            }
            
            //fix second component to 0
            wdDate = correctSecondComponent(date: wdDate, calendar: calendar)
            correctedDate.append(wdDate)
        }
        return correctedDate
    }
    
}
func formattedDaysInThisWeek(date : Date , arr : [Int]) -> [Date] {
    var arrDate = [Date]()
    let value = getWeekDay(date: date)
    print(value)
    print(arr)
    for i in 0..<arr.count{
        let date = endNotificationDate(days: arr[i], date: date)
        arrDate.append(date)
    }
    return arrDate
}
func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
    let second = calendar.component(.second, from: date)
    let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
    return d
}
enum weekdaysComparisonResult {
    case before
    case same
    case after
}

func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult{
    if w1 != 1 && w2 == 1 {return .before}
    else if w1 == w2 {return .same}
    else {return .after}
}

func viewIndexPathInTableView(_ cellItem: UIView, tableView tblView: UITableView) -> IndexPath? {
    let pointInTable: CGPoint = cellItem.convert(cellItem.bounds.origin, to: tblView)
    if let cellIndexPath = tblView.indexPathForRow(at: pointInTable){
        return cellIndexPath
    }
    return nil
}

func viewIndexPathInCollectionView(_ cellItem: UIView, collView: UICollectionView) -> IndexPath? {
    let pointInTable: CGPoint = cellItem.convert(cellItem.bounds.origin, to: collView)
    if let cellIndexPath = collView.indexPathForItem(at: pointInTable){
        return cellIndexPath
    }
    return nil
    
}

var player: AVAudioPlayer?
func playSound() {
    guard let url = Bundle.main.url(forResource: "ClickSound", withExtension: "mp3") else {
        print("error")
        return
    }
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url)
        guard let player = player else { return }
        player.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func showOpenSettingAlert(sender : UIViewController){
    let alrt = UIAlertController(title: "Media Access Denied", message: "", preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
        
    })
    let Cancel = UIAlertAction(title: "Setting", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    })
    alrt.addAction(ok)
    alrt.addAction(Cancel)
    sender.present(alrt, animated: true, completion: nil)
}

func changeDateFormatForReminder(date : String,fromFormat : String = "dd-MMMM-yyyy", toFormat : String = "yyyy-MM-dd")-> String{
    dateFormatter.dateFormat = fromFormat
    let date1 = dateFormatter.date(from: date)
    dateFormatter.dateFormat = toFormat
    let str = dateFormatter.string(from: date1!)
    return str
}



func weekDayarr(days : String)->[Int]{
    var weekDayArr = [Int]()
    let arryOfDays = days.components(separatedBy: ", ")
    for i in 0..<arryOfDays.count{
        let day = arryOfDays[i]
        switch day {
        case "Sun":
            weekDayArr.append(1)
        case "Mon":
            weekDayArr.append(2)
        case "Tue":
            weekDayArr.append(3)
        case "Wed":
            weekDayArr.append(4)
        case "Thu":
            weekDayArr.append(5)
        case "Fri":
            weekDayArr.append(6)
        case "Sat":
            weekDayArr.append(7)
        default:
            print("")
        }
        
    }
    return weekDayArr
    
    
}




func isValidPhone(_ phoneNumber: String) -> Bool {
    let mobileNumberPattern = "[123456789][0-9]{9}"
    let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)
    return mobileNumberPred.evaluate(with: phoneNumber)
}

func getUrlOfImage(completion: @escaping (_ localIdentifier: URL?) -> Void) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    fetchOptions.fetchLimit = 1
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    if (fetchResult.firstObject != nil){
        let lastImageAsset: PHAsset = fetchResult.firstObject!
        lastImageAsset.requestContentEditingInput(with: nil, completionHandler: { (editing:PHContentEditingInput?, info) in
            if let contentEditing = editing{
                DispatchQueue.main.async {
                    completion(contentEditing.fullSizeImageURL)
                }
            }else{
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
    else{
        completion(nil)
    }
    
}



func setOffTintSwictBtn(btn : UISwitch){
    btn.tintColor = lightTextColor
    btn.layer.cornerRadius = 16
    btn.backgroundColor = lightTextColor
    
}
func trackingScreenForGoogleAnalytics(screenName : String){
    
    //    guard let tracker = GAI.sharedInstance().defaultTracker else { return }
    //    tracker.set(kGAIScreenName, value: screenName)
    //    guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
    //    tracker.send(builder.build() as [NSObject : AnyObject])
}

/*func isConnection()->Bool{
    
    let reachability = Reachability()!
    let status = reachability.currentReachabilityStatus
    if status == .notReachable{
        return false
    }
    return true
}*/








extension Date{
    func dayAgo()->String{
        let weekday = getWeekDay(date: self)
        switch weekday {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    
    func dateInString()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFromatter.string(from: self)
    }
    
    func dateInStringWithAmPm()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "yyyy-MM-dd hh:mm a"
        return dateFromatter.string(from: self)
    }
    
    func dateInTime()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateFormat = "hh:mm a"
        return dateFromatter.string(from: self)
    }
    
    func dateInMedium()->String{
        let dateFromatter = DateFormatter.init()
        dateFromatter.dateStyle = .medium
        return dateFromatter.string(from: self)
    }
}

func loadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?){
    print("IMAGE URL--->>>>" , url)
    activity?.startAnimating()
    let urlStr = URL.init(string: url)
    imageView.sd_setImageWithPreviousCachedImage(with: urlStr, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil) {  (image, error, imageCacheType, imageUrl) in
        if image != nil{
            activity?.stopAnimating()
            imageView.image = image
        }else{
            imageView.image = defaultImage
        }
        activity?.stopAnimating()
    }
}

func loadProfilePic(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , name:String){
    print("IMAGE URL--->>>>" , url)
    activity?.startAnimating()
    let urlStr = URL.init(string: url)
    imageView.sd_setImageWithPreviousCachedImage(with: urlStr, placeholderImage: nil, options: SDWebImageOptions(rawValue: 0), progress: nil) {  (image, error, imageCacheType, imageUrl) in
        if image != nil{
            activity?.stopAnimating()
            imageView.image = image
        }
        activity?.stopAnimating()
    }
}

func downloadImage(_ url :String , _ imageView:UIImageView , activity:UIActivityIndicatorView? , defaultImage:UIImage?){
    print("IMAGE URL--->>>>" , url)
    activity?.startAnimating()
    let urlStr = URL.init(string: url)
    let manager = SDWebImageDownloader.shared()
    manager.downloadImage(with: urlStr, options: .highPriority, progress: nil) { (image:UIImage?, data:Data?, erroe:Error?, success:Bool) in
        if image != nil{
            activity?.stopAnimating()
            imageView.image = image
        }else{
            imageView.image = defaultImage
        }
        activity?.stopAnimating()
    }
}

func JSONtoString(_ data:[String:Any])->String?{
    do {
        let data = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        let string = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return string as String?
    } catch  {
        print(error.localizedDescription)
    }
    return nil
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

extension UIViewController {
    func showInternetAlert(){
        let alert = UIAlertController.init(title: "Error", message: "It seems there is no Internet connection.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
func isEmpty(_ text :String?)->Bool {
    if let value = text {
        let trimmed =  value.trimmingCharacters(in: .whitespaces)
        if trimmed.characters.count > 0 {
            return false
        }
        if trimmed == "" {
            return true
        }
        return false
    }
    return true
}

enum DeviceType :String{
    case iPhone4S
    case iPhone5
    case iPhone6
    case iPhone7
    case iPhone8Plus
    case iPhoneX
}

func currentUserDevice()->DeviceType {
    if SCREEN_HEIGHT == 480.0{
        return .iPhone4S
    }else if SCREEN_HEIGHT == 568.0 {
        return .iPhone5
    }else if SCREEN_HEIGHT == 667.0 {
        return .iPhone6
    }else if SCREEN_WIDTH == 375.0 && SCREEN_HEIGHT == 812.0 {
        return .iPhoneX
    }else if SCREEN_WIDTH == 414.0 && SCREEN_HEIGHT == 736.0 {
        return .iPhone8Plus
    }else{
        return .iPhone7
    }
}

extension String {
    
    func date()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = longTimeFormat
        //print(dateFormatter.date(from: self))
        return dateFormatter.date(from: self)
    }
    
    func yyMMddDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //print(dateFormatter.date(from: self))
        return dateFormatter.date(from: self)
    }
    func yyMMddHHmmssDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        //print(dateFormatter.date(from: self))
        return dateFormatter.date(from: self)
    }
    func yyMMdd_HH_mm_a_Date()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = TimeFormat
        print(dateFormatter.date(from: self))
        return dateFormatter.date(from: self)
    }
    
    func fullDate()->Date?{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = longTimeFormat
        //print(dateFormatter.date(from: self))
        return dateFormatter.date(from: self)
    }
    
    func dateInTime()->String{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self.fullDate()!)
    }
    
    func dateInArabic()->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if let date = formatter.date(from: self) {
            formatter.locale = Locale(identifier: "ar_DZ")
            formatter.dateFormat = "EEEE, d, MMMM, yyyy hh:mm a"
            let outputDate = formatter.string(from: date)
            return outputDate
        }
        return ""
    }
    
    func dateInMediumFormat()->String{
        let dateFormatter = DateFormatter.init()
        let component = self.components(separatedBy: " ")
        if component.count > 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: component[0]){
                dateFormatter.dateStyle = .medium
               return dateFormatter.string(from: date)
            }
            return ""
        }
        return ""
    }
    func yyyyMMddString()->String?{
        let dateFormatter = DateFormatter.init()
        let component = self.components(separatedBy: " ")
        if component.count > 0 {
            return component[0]
        }
        return nil
    }
    
    func hhmmss()->[String]?{
        let dateFormatter = DateFormatter.init()
        let component = self.components(separatedBy: " ")
        if component.count > 1 {
            let components = component[1].components(separatedBy: ":")
            return components
        }
        return nil
    }
    
    func dateInLongFormat()->Date{
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = TimeFormat
        return dateFormatter.date(from: self)!
    }
}


func randomString(length: Int) -> String {
    let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}




func AttriButedText(str1 : String,color1:UIColor ,str2 : String,color2:UIColor) -> NSAttributedString{
    
    let attrStr1 = NSMutableAttributedString.init(string: str1)
    attrStr1.addAttribute(NSAttributedStringKey.foregroundColor, value: color1, range: NSMakeRange(0, attrStr1.length))
    attrStr1.addAttribute(NSAttributedStringKey.font, value: getPoppinsFont(style: .Medium, size: 15)!, range: NSMakeRange(0, attrStr1.length))
    
    let attrStr2 = NSMutableAttributedString.init(string: str2)
    
    attrStr2.addAttribute(NSAttributedStringKey.font, value: getPoppinsFont(style: .Regular, size: 13)!, range: NSMakeRange(0, attrStr2.length))
    attrStr1.append(attrStr2)
    
    return attrStr1
}



func addRoundedLayer(radius:CGFloat , view :UIView) {
    view.clipsToBounds = false
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 0.6
    view.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
    view.layer.shadowRadius = 2
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: radius).cgPath
}

extension UIView{
    func shadow(radius:CGFloat , color:UIColor , _ opacity:Float) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
    }
}

extension UIView {
    func border(width:CGFloat , color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

}
extension UITextField {
    func attributedPlaceHolder(color:UIColor) {
        if let text = self.placeholder {
            self.attributedPlaceholder = NSAttributedString(string: text,
                                                            attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
}


func getFont(_ name:String, _ size:CGFloat)->UIFont? {
    return UIFont.init(name: name, size: size*widthFactor)
}

func addBottomShadow(view:UIView) {
    view.layer.shadowOffset = CGSize(width: 2.0, height: 0.0)
    view.layer.shadowRadius = 2.0
    view.layer.shadowColor = UIColor.darkGray.cgColor
    view.layer.shadowOpacity = 1.0
}





extension UIViewController {
    
    func showOpenSettingAlert(title:String , message :String , completion:@escaping ()->Void){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cancel", style: .default, handler: {(_ alert: UIAlertAction) -> Void in
            completion()
        })
        let Cancel = UIAlertAction(title: "Open-Settings", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.openURL(settingsUrl)
            }
        })
        alrt.addAction(ok)
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
    func showDeniedLocationlAlert(title:String , message :String){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "Open-Settings", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.openURL(settingsUrl)
            }
        })
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
    func showCantFindLocationlAlert(title:String , message :String , completion:@escaping ()-> Void){
        let alrt = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let Cancel = UIAlertAction(title: "Retry", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            completion()
        })
    
        alrt.addAction(Cancel)
        self.present(alrt, animated: true, completion: nil)
    }
    
}


func isDataSizeOverFlow(data:NSData , maxSize:CGFloat)->Bool{
    var size:CGFloat = CGFloat(data.length)
    size = (size / 1024.0 / 1024.0)
    if size <= maxSize{
        return false
    }
    return true
}



func directions(lat:Double? ,long:Double?) {
    if lat != nil && long != nil{
        if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!){
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))&directionsmode=driving")! as URL)
        }else{
            UIApplication.shared.openURL(NSURL(string:
                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(String(describing: lat!)),\(String(describing: long!))")! as URL)
        }
    }
}
    

extension UIScrollView {
    func shouldPaginate()->Bool {
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - self.frame.size.height
        if (maximumOffset - currentOffset <= 10) {
            return true
        }
        return false
    }
}
  

extension UITextField {
    func addLeftView() {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftViewMode = .always
        self.leftView = view
    }
    func addRIghtView() {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12, height: self.frame.height))
        self.rightViewMode = .always
        self.rightView = view
    }
}

extension UIView {
    func senderCellView(radius:CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .bottomLeft , .bottomRight], cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path  = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}



func getPlaceholderName(name:String?) ->String{
    guard  let str = name  else {
        return ""
    }
    var placeholder_name:String = ""
    let components = str.components(separatedBy: " ")
    if components.count > 1 {
        if (components[0] as NSString) != "" {
            placeholder_name = (components[0] as NSString).substring(to: 1)
            placeholder_name.append(" ")
        }
        if (components[1] as NSString) != "" {
            placeholder_name.append((components[1] as NSString).substring(to: 1))
        }
    }else if components.count == 1{
        if (components[0] as NSString) != "" {
            placeholder_name.append((components[0] as NSString).substring(to: 1))
        }
    }
    return placeholder_name
}


extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}

func image(with view: UIView) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    defer { UIGraphicsEndImageContext() }
    if let context = UIGraphicsGetCurrentContext() {
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    return nil
}



extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours, locations: nil)
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.cornerRadius = 20
        self.layer.insertSublayer(gradient, at: 0)
        self.clipsToBounds = true
    }
}

func thumbnail(_ sourceURL:URL) -> UIImage? {
    let asset = AVAsset.init(url: sourceURL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    let time = CMTime(seconds: 1, preferredTimescale: 1)
    let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil)
    if imageRef == nil {return nil}
    return UIImage.init(cgImage: imageRef!)
}
