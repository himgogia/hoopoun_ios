//
//  ChangePasswordViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate {

    var oldPasswordTextField : UITextField!
    var newPasswordTextField : UITextField!
    var confirmPasswordTextField : UITextField!
    @IBOutlet weak var updateTable: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    var fromViewController : NSString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.fromViewController as String == kchangePassword{
            return 3
        }
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
    }
    
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 15
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: SignupCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SignupCell
        
        tableView.register(UINib(nibName: "SignupCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? SignupCell)!
        
        cell.textField.delegate = self
        cell.textField.isSecureTextEntry = true
        
        if self.fromViewController as String == kchangePassword{
           
            self.navigationItem.title = "Change Password"
            updateButton.setTitle("CHANGE PASSWORD", for: UIControlState.normal)
            
            if indexPath.section == 0{
                
                cell.textField.placeholder = "Enter Old Password"
                oldPasswordTextField = cell.textField
                cell.logoImageView.image = UIImage(named:"password")!
                oldPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            }
                
           else if indexPath.section == 1{
                
                cell.textField.placeholder = "Enter New Password"
                newPasswordTextField = cell.textField
                cell.logoImageView.image = UIImage(named:"password")!
                newPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            }
            else{
                cell.textField.returnKeyType = UIReturnKeyType.done
                
                cell.textField.placeholder = "Confirm New Password"
                confirmPasswordTextField = cell.textField
                cell.logoImageView.image = UIImage (named :"password")
                confirmPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            }
        }
        else{
            self.navigationItem.title = "Update Password"

            if indexPath.section == 0{
                
                cell.textField.placeholder = "Enter New Password"
                newPasswordTextField = cell.textField
                cell.logoImageView.image = UIImage(named:"password")!
                newPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            }
            else{
                cell.textField.returnKeyType = UIReturnKeyType.done
                
                cell.textField.placeholder = "Confirm New Password"
                confirmPasswordTextField = cell.textField
                cell.logoImageView.image = UIImage (named :"password")
                 confirmPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            }
        
        }
        
        
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
    
    @IBAction func updateButton_clicked(_ sender: AnyObject) {
        
         if validation() { // check update password validation
            
        resignKeyboard()
        updatePasswordAPI()
    
        }
    }
    
    @IBAction func backButon_clicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // creat new account
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if self.fromViewController as String == kchangePassword{
            
            if textField == oldPasswordTextField {
                newPasswordTextField.becomeFirstResponder()
            }
            else if textField == newPasswordTextField {
                confirmPasswordTextField.becomeFirstResponder()
            }
            else if textField == confirmPasswordTextField{
                confirmPasswordTextField.resignFirstResponder()
            }
        }
        else{
            
            if textField == newPasswordTextField {
                confirmPasswordTextField.becomeFirstResponder()
            }
            else if textField == confirmPasswordTextField{
                confirmPasswordTextField.resignFirstResponder()
            }
        }
       
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
//        
//        if newLength == 11 {
//            return false
//        }
        
        return true
    }
  
    func resignKeyboard(){
    
        if  self.fromViewController as String == kchangePassword {
            oldPasswordTextField.resignFirstResponder()
        }
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    func updatePasswordAPI(){
        
        let  loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        let requestURL : URL!
        
        if self.fromViewController as String == kchangePassword{
            
            if  self.fromViewController as String == kchangePassword {
                params = [
                    knewPassword : newPasswordTextField.text!,
                    koldPassword : oldPasswordTextField.text!,
                    kconfirmPassword : confirmPasswordTextField.text!,
                    kid : loginInfoDictionary[kid] as! String,
                ]
                
            }
            else{
                
                params = [
                    knewPassword : newPasswordTextField.text!,
                    kconfirmPassword : confirmPasswordTextField.text!,
                    kid : loginInfoDictionary[kid] as! String,
                ]
            }
            
            requestURL = URL(string: String(format: "%@%@",kBaseUrl,"changePassword"))!
        }
        else{
            params = [
                kpassword : newPasswordTextField.text!,
                kid : loginInfoDictionary[kid] as! String,
            ]
            requestURL = URL(string: String(format: "%@%@",kBaseUrl,"updateOtpPassword"))!
        }
      
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        let message = dict[kMessage]

                        if self.fromViewController as String == kchangePassword{

                        alertController(controller: self, title: "Password Changed", message:message! as! String, okButtonTitle: "Got it", completionHandler: {(index) -> Void in
                            self.navigationController?.popViewController(animated: true)
                        })
                        }
                        else{
                            
                            alertController(controller: self, title: "Password Update", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                               
                               let controllers = self.navigationController?.viewControllers
                                
                                for controller in controllers! {
                                    
                                    if controller.isKind(of: SignInViewController.self){
                                       self.navigationController?.popToViewController(controller, animated: true)
                                    }
                                }
                                

                            })
                        
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
        
    }
    

    
    // MARK - Validation
    
    func validation()-> Bool {
        
        // change passowrd
        if  self.fromViewController as String == kchangePassword {
            
            if oldPasswordTextField.text == ""{
            alertController(controller: self, title: "", message: "Please enter Old Password.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            }
        }
        
        if newPasswordTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter New Password.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
            
        else if confirmPasswordTextField.text == "" {
            alertController(controller: self, title: "", message: "Please enter Confirm Password", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if newPasswordTextField.text != confirmPasswordTextField.text {
            
            alertController(controller: self, title: "", message: "New Password and Confirm Password must be same.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }


}
