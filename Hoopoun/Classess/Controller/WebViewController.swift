//
//  WebViewController.swift
//  Hoopoun
//
//  Created by Chankit on 10/13/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate{

    @IBOutlet var bannerImageViewHeightConstant: NSLayoutConstraint!
    @IBOutlet var webView: UIWebView!
    var headerStr = String()
    var URLStr = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        if(headerStr == KAboutus)
        {
            self.navigationItem.title = "About Us"
            URLStr = String(format: "%@",KAboutUsURL)
        }
        else if (headerStr == kterms)
        {
            self.navigationItem.title = "Terms & Conditions"

            URLStr = String(format: "%@",KTermAndConditionURL)
        }
        
        if let url = URL(string:  String(format: "%@",URLStr)) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
   /* func getWebViewData(){
        
        
        var params : NSMutableDictionary = [:]
       
        print(params)
      
        let requestURL: URL = URL(string: String(format: "%@",URLStr))!
        
        NetworkManager.sharedInstance.getRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: Dictionary?) in
            
            if response?.isEmpty == false {
                
                DispatchQueue.main.async {
                    
                    let dict    = response
                    
                    
                    
                    let code  = response?[kPayload]?["verificationStatus"] as? String
                    
                    
                    if  code == "VERIFICATION_COMPLETED"
                    {
                        print(response![kPayload]!)
                        
                        if self.fromViewController as String == kforgotPassword{
                            
                            self.performSegue(withIdentifier: kChangePasswordSegueIdentifier, sender: nil)
                            
                        }
                        else{
                            
                            let verifyDictionary:NSMutableDictionary = dict[kPayload] as! NSMutableDictionary
                            verifyDictionary.setValue(self.loginInfoDictionary.value(forKey: kid), forKey: kid)
                            
                            kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:verifyDictionary), forKey: kloginInfo)
                            
                            self.performSegue(withIdentifier: kProfileSegueIdentifier, sender: nil)
                        }
                        
                        
                        
                        
                        
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
        }
    }*/
}
