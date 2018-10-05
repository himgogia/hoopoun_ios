//
//  SignupViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 17/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate {
    
    var nameTextField : UITextField!
    var mobileNumberTextField : UITextField!
    
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var signupTable: UITableView!
    
    var incommingType : NSString!
    var socialDictionary: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        webView.scrollView.isScrollEnabled = false

        
        // Term & Condition
        let termCondition:String = "<font face = 'arial'><span style= 'text-align:center;font-size:16px; font-family:SFUIText-semibold;color:#FFFFFF'><p>By Signing Up, I agree to the <a href='' style='color:#FFFFFF;'>Terms & Conditions</a></p></span></font>"
        webView.loadHTMLString(termCondition, baseURL: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK-: Input accesory view
    
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
      //  toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        cancelButton.tintColor = UIColor.black
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        view.endEditing(true)
    }
    
    func cancelPressed() {
        view.endEditing(true) // or do something
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        cell.textField.delegate = self
      
        if indexPath.section == 0{
            
            cell.textField.placeholder = "Name"
            nameTextField = cell.textField
            cell.logoImageView.image = UIImage(named:"user")!
            nameTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        else{
            cell.textField.returnKeyType = UIReturnKeyType.done
            cell.textField.keyboardType = UIKeyboardType.phonePad
            
            cell.textField.placeholder = "Mobile No"
            mobileNumberTextField = cell.textField
            cell.logoImageView.image = UIImage (named :"phone")
             mobileNumberTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        
        if self.incommingType == kSocialLogin as NSString {
            
            let userName = self.socialDictionary["name"] as? String;
            nameTextField.text = userName
        }
        else if self.incommingType == kguestUser as NSString{
            self.navigationItem.leftBarButtonItem = nil
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    // MARK: Webview Delegate/////////////////////////////////////
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked
        {
            let WebViewController = self.storyboard?.instantiateViewController(withIdentifier: kWebViewController) as? WebViewController
            WebViewController?.headerStr = kterms
            self.navigationController?.pushViewController(WebViewController!, animated: true)        }
        return true
    }
    
    
    // MARK: - Button Action///////////////////////////////////
    
    @IBAction func signupButton_clicked(_ sender: AnyObject) {
        
        
        if validation() { // check sign in validation
            siginupAPI()
        }
    }
    
    @IBAction func backButon_clicked(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // creat new account
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            mobileNumberTextField.becomeFirstResponder()
        }
        else if textField == nameTextField{
            mobileNumberTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if newLength > 20 {
            return false
        }
        
        return true
    }
    
    
    func siginupAPI(){
        
        // resign text field
        nameTextField.resignFirstResponder()
        mobileNumberTextField.resignFirstResponder()
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kname: nameTextField.text!,
            kmobileNumber : mobileNumberTextField.text!,
            kregister_type : self.socialDictionary.value(forKey: kregister_type) ?? "N",
            ksocialId : self.socialDictionary.value(forKey: ksocialId) ?? "",
            kstype : self.socialDictionary.value(forKey: kstype) ?? "",
            kdeviceToken : appDelegate.deviceToken,
            kdeviceType : "i"
        ]
        print(params)
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"userSignup"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject: dict[kPayload] as Any ), forKey: kloginInfo)
                        
                        self.sendOTP()
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
    
    func sendOTP(){
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kmobileNumber : mobileNumberTextField.text!,
            kid : loginInfoDictionary[kid] as! String,
            
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"sendOtp"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        
                        let signUpDictioary:NSMutableDictionary = dict[kPayload] as! NSMutableDictionary
                        signUpDictioary.setValue(loginInfoDictionary.value(forKey: kid), forKey: kid)
                        
                        //                      kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:signUpDictioary), forKey: kloginInfo)
                        self.performSegue(withIdentifier: kVerifySegueIdentifier, sender: nil)
                        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if nameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter Name.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
            
        else if mobileNumberTextField.text == "" {
            alertController(controller: self, title: "", message: "Please enter Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else  if (mobileNumberTextField.text!.characters.count != 10) {            alertController(controller: self, title: "", message: "Please enter valid Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
        })
            
            return false;
        }
        
        return true;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kVerifySegueIdentifier{
            
            let  verifyView :VerifyViewController = segue.destination as! VerifyViewController
            verifyView.incommingType  = self.incommingType;
            
            if (self.socialDictionary != nil) {
                verifyView.socialDictionary = self.socialDictionary
                
            }
  
        }
        
    }
}
