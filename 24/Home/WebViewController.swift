//
//  WebViewController.swift
//  24
//
//  Created by sriVathsav on 1/10/1397 AP.
//  Copyright © 1397 sri. All rights reserved.
//

import UIKit
import WebKit

let main = UIStoryboard.init(name: "Main", bundle: nil)

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var url: String?
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        loadWebPage(Url: url!)
    }
    
    func loadWebPage(Url: String){
        guard let url = URL(string: Url) else {return}
        self.showLoader()
        let request = URLRequest.init(url: url)
        webView.loadRequest(request)
        titleLabel.text = pageTitle
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.popVC()
    }
    
    
    class func instance()->WebViewController{
        let vc = main.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        return vc
    }
}





extension WebViewController :UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideLoader()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.hideLoader()
    }
}

