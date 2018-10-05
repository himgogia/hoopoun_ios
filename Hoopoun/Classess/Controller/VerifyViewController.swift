//
//  VerifyViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 17/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController,UITextFieldDelegate {
    // Outlet
    @IBOutlet weak var firstTextField: UITextField!
        @IBOutlet weak var seconTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var mobileNumberLabel: UILabel!
     var loginInfoDictionary :NSMutableDictionary!
    
    var incommingType : NSString!
    var socialDictionary: NSDictionary = NSDictionary()
    
    var mobileNumber : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstTextField.delegate = self
        seconTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        
        // set mobile number

        
        if self.incommingType == kforgotPassword as NSString {
         
            let mobileNumber =  self.mobileNumber
            let index1 = mobileNumber?.index((mobileNumber?.endIndex)!, offsetBy: -4)
            let substring1 = mobileNumber?.substring(from: index1!)
            mobileNumberLabel.text = String(format: "+91-XXXXXX%@", substring1!)
        }
        else{
      
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        let mobileNumber =  loginInfoDictionary[kmobileNumber] as! String
        let index1 = mobileNumber.index(mobileNumber.endIndex, offsetBy: -4)
        let substring1 = mobileNumber.substring(from: index1)
        mobileNumberLabel.text = String(format: "+91-XXXXXX%@", substring1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if newLength == 2 {
            
            let text = textField.text
            
            if text?.utf16.count==1{
                switch textField{
                case firstTextField:
                    seconTextField.becomeFirstResponder()
                case seconTextField:
                    thirdTextField.becomeFirstResponder()
                case thirdTextField:
                    fourthTextField.becomeFirstResponder()
                case fourthTextField:
                    fourthTextField.resignFirstResponder()
                default:
                    break
                }
            }
            return true
        }
        
       
        return true
    }
    
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        
        let textField:UITextField = sender as! UITextField;
        
        let text = textField.text
        
        if text?.utf16.count==1{
            switch textField{
            case firstTextField:
                seconTextField.becomeFirstResponder()
            case seconTextField:
                thirdTextField.becomeFirstResponder()
            case thirdTextField:
                fourthTextField.becomeFirstResponder()
            case fourthTextField:
                fourthTextField.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
func textFieldDidChange(textField: UITextField){
        
    
    }
    
    
    // MARK: Button Clicked
    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func resendButton_clicked(_ sender: AnyObject) {
        
        reSendOTP()
    }
    @IBAction func verifyButton_clicked(_ sender: AnyObject) {
        
        if validation() == true {
              verify()
        }
        
    }
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if firstTextField.text == "" && seconTextField.text == "" && thirdTextField.text == "" && fourthTextField.text == "" {
            alertController(controller: self, title: "", message: "Please enter OTP.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else  if firstTextField.text == "" || seconTextField.text == "" || thirdTextField.text == ""||fourthTextField.text == "" {
            alertController(controller: self, title: "", message: "Please enter valid OTP.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
            
        
        
        return true;
    }
    
    // MARK: - APIS
    
    func reSendOTP(){
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kmobileNumber : loginInfoDictionary[kmobileNumber]!,
            kid : loginInfoDictionary[kid]!,
            
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"sendOtp"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(response![kPayload]!)
                        
                        alertController(controller: self, title: "", message:response![kMessage] as! String , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                            self.firstTextField.text = ""
                            self.seconTextField.text = ""
                            self.thirdTextField.text = ""
                            self.fourthTextField.text = ""

                        })
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
    
    func verify(){
        
     
        let otp = String(format: "%@%@%@%@",firstTextField.text!,seconTextField.text!,thirdTextField.text!,fourthTextField.text!)
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            "otp": otp,
            kverificationId : "",
            kid : loginInfoDictionary[kid] as! String,
        ]
        
        print(params)

        let paramString = String(format:"verificationId=0%@&id=%@&otp=%@","",loginInfoDictionary[kid] as! String,otp)
        
        
       
        let requestURL: URL = URL(string: String(format: "%@%@?%@",kBaseUrl,"verifyPhone",paramString))!
        
        NetworkManager.sharedInstance.getRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: Dictionary?) in
            
            if response?.isEmpty == false {
                
                DispatchQueue.main.async {
                    
                    let dict    = response

                    let payload: NSMutableDictionary = (response?[kPayload] as?NSMutableDictionary)!
                    let code  = payload.value(forKey: "responseCode")
                    
                    let codeString :String = (String(format: "%@", code as! CVarArg))
                    
                    if  codeString == "200"
                    {
                        
                        self.firstTextField.text = ""
                        self.seconTextField.text = ""
                        self.thirdTextField.text = ""
                        self.fourthTextField.text = ""
                        
                        print(response![kPayload]!)
                        
                        if self.incommingType as String == kforgotPassword{
                        
                            self.performSegue(withIdentifier: kChangePasswordSegueIdentifier, sender: nil)
                            
                        }
                        else{
                    
                            let verifyDictionary:NSMutableDictionary = dict![kPayload] as! NSMutableDictionary
                            verifyDictionary.setValue(self.loginInfoDictionary.value(forKey: kid), forKey: kid)
                            
                            kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:verifyDictionary), forKey: kloginInfo)
                          
                            self.performSegue(withIdentifier: kProfileSegueIdentifier, sender: nil)
                        }
                    
                    }
                    else
                    {
                        let message = dict![kMessage]
                        
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
    
    
     // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kProfileSegueIdentifier{
            
            let  profileView :ProfileViewController = segue.destination as! ProfileViewController
            profileView.incommingType = self.incommingType;
            
            if (self.socialDictionary != nil) {
                profileView.socialDictionary = self.socialDictionary
                
            }
            
            else if segue.identifier == kChangePasswordSegueIdentifier{
                
                let  changePassword :ChangePasswordViewController = segue.destination as! ChangePasswordViewController
                changePassword.fromViewController = self.incommingType;
                
            }
            
            
        }
        
    }
    
}
