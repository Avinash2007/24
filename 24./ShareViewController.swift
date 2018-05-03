//
//  ShareViewController.swift
//  24.
//
//  Created by sri on 22/03/18.
//  Copyright © 2018 sri. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    private var urlString: String?
    private var textString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dt : 18/04/2018
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let attachments = item.attachments as? [NSItemProvider] {
                for attachment: NSItemProvider in attachments {
                    if attachment.hasItemConformingToTypeIdentifier("public.url") {
                        attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
                            if let shareURL = url as? NSURL {
                                // Do stuff with your URL now.
                                print("URL retrieved: \(shareURL)")
                            }
                        })
                    } else if attachment.hasItemConformingToTypeIdentifier("public.text") {
                        // This means Share Extension has no URL. It will call in YouTube because YouTube Share URL As Text.
                        guard let text = textView.text else {return}
                        print("In URL/Text as share text : \(text)")
                    }
                }
            }
        }
        
    }
    
    override func isContentValid() -> Bool {
        if urlString != nil || textString != nil {
            if !contentText.isEmpty {
                return true
            }
        }
        return true
    }
 
    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}


