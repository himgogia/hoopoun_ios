//
//  AddStoreReviewViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 16/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class AddStoreReviewViewController: UIViewController {
    
    var storeDictioary : NSMutableDictionary? = nil
    
    @IBOutlet var storeNameLabel: UILabel!
    @IBOutlet var storeAddressLabel: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    @IBOutlet var reviewTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        print(self.storeDictioary as Any)
        
        self.setInitialData(infoDict: self.storeDictioary!)
        
        let window = UIApplication.shared.keyWindow!
        let addReviewButton = window.viewWithTag(2017)
        addReviewButton?.isHidden = true
        
        
        let saveButton = UIButton()
        saveButton.setTitle("Save", for: UIControlState.normal)
        saveButton.frame = CGRect(x:0 , y: 2, width: 40, height: 34)
        saveButton.titleLabel?.font = UIFont(name:"SFUIText-Semibold", size: 15.0)
        saveButton.backgroundColor = UIColor.clear
        saveButton.addTarget(self, action: #selector(saveButton_Clicked), for:UIControlEvents.touchUpInside)
        let item2 = UIBarButtonItem(customView: saveButton);             self.navigationItem.setRightBarButtonItems([item2], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        let window = UIApplication.shared.keyWindow!
//        let addReviewButton = window.viewWithTag(2017)
//        addReviewButton?.isHidden = false
//    }
    
    func setInitialData(infoDict:NSMutableDictionary){
        
        if infoDict.isKind(of: NSMutableDictionary.self) {
            
            // Address
            self.storeAddressLabel.text = infoDict.value(forKey: kaddress) as? String
            
            // store name
            self.storeNameLabel.text = infoDict.value(forKey: kstore_name) as? String
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
 // Button Action
    @IBAction func backButton_Clicked(_ sender: Any) {
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)

    }
    
     func saveButton_Clicked(_ sender: Any) {
        
        if validation() == true {
            
            // Address
            addReview(offerId: (self.storeDictioary?.value(forKey: koffer_id) as? String)!)
        }
    }
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        let trimmedString = reviewTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if ratingView.rating == 0 {
            
            alertController(controller: self, title: "", message: "Please select Rating", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
        else  if trimmedString == "" {
                
                alertController(controller: self, title: "", message: "Please enter Review text", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                })
                return false;
        }
       
        
        return true;
    }
    
    
    //MARK:- APIS CALL
    func addReview(offerId : String){
        
        reviewTextView.resignFirstResponder()
        
         let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        var params : NSMutableDictionary = [:]
        
            params = [
                
                koffer_id : offerId,
                kstoreId : "",
                "user_id" : loginInfoDictionary.value(forKey: kid)!,
                krating : ratingView.rating,
                kreview : reviewTextView.text
            ]
        
        print(params)
        
    let baseUrl = String(format: "%@%@",kBaseUrl,"storeReview")
        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        
                        alertController(controller: self
                            , title: "", message:(dict[kMessage] as? String)!, okButtonTitle: "OK", completionHandler: {(index)-> Void in
                                self.navigationController?.isNavigationBarHidden = true

                                self.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }
            }
            
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
