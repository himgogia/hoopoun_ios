//
//  RedeemOfferViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 24/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class RedeemOfferViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var offerTextField: UITextField!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var redeemOfferTable: UITableView!
    
    @IBOutlet var submitButton: UIButton!
    var amountTextField : UITextField!
    var OTPTextField : UITextField!
    var amountString : String = ""
    
    var  offerCodeDictionary : NSMutableDictionary!
    var  offerInfoDictionary : NSMutableDictionary!
    var verificationId : String!
    
    var isGetOTP : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isGetOTP = false
        // show navigation bar if hide
        self.navigationController?.isNavigationBarHidden = false
        
        hintLabel.text = "All in good time, dear customer! Please enter your bill amount and get OTP from merchant. Use the OTP and get your offer redeemed here"
        
        
        let totalredeem = (self.offerCodeDictionary.value(forKey: "totalredeem") as! NSString).doubleValue
        
        let redeemoCount : NSInteger  = NSInteger(totalredeem + 1)
        let offerCode : String = (self.offerCodeDictionary.value(forKey: "offerCode") as! String)
        
        let s: String = String(format:"%d", redeemoCount)
        offerTextField.text = NSString(format: "%@-%@",offerCode,s) as String
        offerTextField.isUserInteractionEnabled = false
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        
        let userID = loginInfoDictionary.value(forKey: kid) as? String
        userIDTextField.text = NSString(format: "UD-%@",userID!) as String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isGetOTP == true {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: RedeemOfferCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RedeemOfferCell
        
        tableView.register(UINib(nibName: "RedeemOfferCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? RedeemOfferCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.textField.delegate = self
        
        if indexPath.row == 0 && isGetOTP == false{
            
            cell.textField.placeholder = "Enter bill amount"
            amountTextField = cell.textField
            amountTextField.text = amountString
            cell.imgView.image = UIImage(named : "rupees")
        }
        else{
            
            hintLabel.text = "An OTP has been sent to merchant,please get OTP from him & verify."
            
            if indexPath.row == 1 && isGetOTP == true{
                
                cell.textField.placeholder = "Enter bill amount"
                cell.textField.isUserInteractionEnabled = false
                
                amountTextField = cell.textField
                amountTextField.text = amountString
                
                cell.imgView.image = UIImage(named : "rupees")
            }
            else{
                cell.textField.returnKeyType = UIReturnKeyType.done
                cell.textField.placeholder = "Enter OTP"
                cell.textField.isSecureTextEntry = true
                OTPTextField = cell.textField
                cell.imgView.image = UIImage(named : "enterOTP")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    //MARK:- Textfield Delegate
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == OTPTextField {
            let newLength = (OTPTextField.text?.characters.count)! + string.characters.count - range.length
            return newLength <= 4
        }
        return true
    }
    
    // MARK:- Button Action
    
    @IBAction func getOTPButton_clicked(_ sender: Any) {
        
        if amountTextField.text == "" {
            alertController(controller: self, title: "", message: "Please enter bill amount", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
        }
        else{
            if isGetOTP == true {
                
                if OTPTextField.text == "" {
                    alertController(controller: self, title: "", message: "Please enter OTP", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    })
                }
                    //                else if OTPTextField.text?.characters.count != 4 {
                    //                    alertController(controller: self, title: "", message: "Please enter valid OTP", okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    //                    })
                    //                }
                else{
                    // submit button action
                    submitRedeemption()
                }
            }
            else{
                getRedeemOTP()
            }
        }
        
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - APIS
    
    
    func getRedeemOTP(){
        
        amountTextField.resignFirstResponder()
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        // param dictionary,
        
        var params : NSMutableDictionary = [:]
        params = [
            klatitude: String(appDelegate.lat),
            klongitude: String(appDelegate.long),
            koffer_id : self.offerInfoDictionary.value(forKey: koffer_id)!,
            "user_id" : loginInfoDictionary.value(forKey: kid) as Any,
            "amount" : amountTextField.text as Any
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"offerTimeDetails"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        let payload: NSMutableDictionary = dict[kPayload] as! NSMutableDictionary
                        
                        let codeNumber = payload.value(forKey: "verificationId")
                        
                        let codeInString:String = String(format: "%@", codeNumber as! CVarArg)
                        
                        self.isGetOTP = true
                        self.amountString = self.amountTextField.text!
                        self.verificationId = codeInString
                        self.submitButton.setTitle("SUBMIT", for: UIControlState.normal)
                        self.redeemOfferTable.reloadData()
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
    }
    func submitRedeemption(){
        
        amountTextField.resignFirstResponder()
        OTPTextField.resignFirstResponder()
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        // param dictionary,
        
        var params : NSMutableDictionary = [:]
        params = [
            
            koffer_id : self.offerInfoDictionary.value(forKey: koffer_id)!,
            "user_id" : loginInfoDictionary.value(forKey: kid) as Any,
            "amount" : amountTextField.text as Any,
            "otp" : OTPTextField.text!,
            "verificationId" : self.verificationId
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"offerRedeemDetails"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    
                    let dict    = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    let message : String =  dict[kMessage] as! String
                    
                    if index == "200"
                    {
                        alertController(controller: self, title: "", message:message , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                            self.navigationController?.isNavigationBarHidden = true
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                    else
                    {
                        
                        alertController(controller: self, title: "", message:message , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        })
                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
        }
    }
    
    
    
    
    
}
