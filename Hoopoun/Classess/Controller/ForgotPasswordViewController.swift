//
//  ForgotPasswordViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 18/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {
    
    // Outlet
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var forgotPasswordTable: UITableView!
    var emailTextField : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        headerLabel.text = "NO WORRIES!!\nJust enter your email address\nor mobile number registered with us."
    }
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: SignupCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SignupCell
        
        tableView.register(UINib(nibName: "SignupCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? SignupCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        cell.textField.delegate = self
        
        if indexPath.row == 0{
            cell.textField.placeholder = "Enter Email ID / Mobile No."
            emailTextField = cell.textField
            cell.logoImageView.image = UIImage (named :"user")
            emailTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    // MARK: Webview Delegate/////////////////////////////////////
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked
        {
            return false
        }
        return true
    }
    
    // MARK: - Button Action///////////////////////////////////
    
    @IBAction func submitButton_clicked(_ sender: AnyObject) {
        
        if validation() == true {
            
//            if isDigits(value: emailTextField.text!) {
            
            self.emailTextField.resignFirstResponder()
            forgotPassword()
   
            // }
           
        }
    }
    
    @IBAction func backButon_clicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // creat new account
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if newLength == 11 && isDigits(value: emailTextField.text!) {
            return false
        }
        
        return true
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if (emailTextField.text == "" && !isDigits(value: emailTextField.text!)) {
            
            alertController(controller: self, title: "", message: "Please enter Email ID/Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else  if (emailTextField.text!.characters.count != 10 && isDigits(value: emailTextField.text!)) {
            
            alertController(controller: self, title: "", message: "Please enter valid Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
            
            
        else if  (isValidEmail(testStr: emailTextField.text!) == false && !isDigits(value: emailTextField.text!)){
            
            alertController(controller: self, title: "", message: "Please enter valid Email Id.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        
        return true;
    }
    
    
    // MARK:- APIs call
    
    func forgotPassword(){
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            "loginId" : self.emailTextField.text ?? "",
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"forgotPassword"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        self.sendOTP(forgotPassDictionary:(dict[kPayload] as? NSDictionary)! )
                    }
                    else if index == "204" {
                        
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            self.navigationController?.popViewController(animated: true)
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
  
    
    func sendOTP(forgotPassDictionary : NSDictionary){
        
        
     
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kmobileNumber : emailTextField.text!,
            kid : forgotPassDictionary[kid] as! String,
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"sendOtp"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
                if (response != nil) {
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(response![kPayload]!)
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:forgotPassDictionary), forKey: kloginInfo)
                        
                        self.performSegue(withIdentifier: kVerifySegueIdentifier, sender: forgotPassDictionary)

                        
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

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kVerifySegueIdentifier {
            let verifyViewController : VerifyViewController = segue.destination as! VerifyViewController
            verifyViewController.incommingType = kforgotPassword as NSString
            verifyViewController.loginInfoDictionary = sender as! NSMutableDictionary
            verifyViewController.mobileNumber = self.emailTextField.text
        }
        
    }


}
