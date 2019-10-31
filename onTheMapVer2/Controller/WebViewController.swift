//
//  webViewController.swift
//  onTheMapVer2
//
//  Created by Hema on 10/22/19.
//  Copyright © 2019 Hema. All rights reserved.
//

import Foundation
import UIKit
import WebKit



class WebViewController: UIViewController, WKUIDelegate {

  
    
    var webData: String!
    
    
    var webView: WKWebView!
    

        override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            let aURL = webData
            print(aURL as Any)
            let myURL = URL(string:aURL!)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }
    
        override func viewWillAppear(_ animated: Bool) {
            print("detail view")
                 
        }
    
    
    
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
        }
    
}
