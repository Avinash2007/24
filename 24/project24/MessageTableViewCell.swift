//
//  MessageTableViewCell.swift
//  project24
//
//  Created by sri on 05/08/17.
//  Copyright © 2017 sri. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getMessages(messageData : Messages){
        
        messageLabel.text = messageData.message
        
    
        if let timeInterval = messageData.timeStamp?.doubleValue{
        let date = NSDate(timeIntervalSince1970: timeInterval)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
            
        timeLabel.text = dateFormatter.string(from: date as Date)
        print("this is the actually date\(dateFormatter.string(from: date as Date))")
            
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //let dateString = dateFormatter.string(from: date as Date)
        //print("formatted date is =  \(dateString)")
        }
    }
}
