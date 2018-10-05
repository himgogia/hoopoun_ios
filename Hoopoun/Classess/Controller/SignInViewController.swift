//
//  SignInViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 16/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit



enum signinCellCount:Int  {
    case email = 0,
    password
}


class SignInViewController: UIViewController,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,GIDSignInDelegate,GIDSignInUIDelegate{
    
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    
    var socialDictionary : NSMutableDictionary = NSMutableDictionary()
    
    var register_type : String = ""
    
    var appDelegate : AppDelegate! = nil
    
    
    // Outlet
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var skipWebview: UIWebView!
    @IBOutlet weak var forgotPasswordWebview: UIWebView!
    @IBOutlet weak var signinTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // set button text
        
        let skipText:String = "<font face = 'SFUIText-Regular'><span style='font-size:16px;text-align: left;color:#FFFFFF'><p><a href='' style='color:#FFFFFF; text-decoration: none'>Skip to Try</a></p>"
        skipWebview.loadHTMLString(skipText, baseURL: nil)
        skipWebview.scrollView.isScrollEnabled = false
        
        let passwordText:String = "<font face = 'SFUIText-semibold'><span style='font-size:16px;text-align: right;color:#3B455D'><p><a href='' style='color:#FFFFFF;text-decoration: none'>Forgot Password</a></p></span></font>"
        forgotPasswordWebview.loadHTMLString(passwordText, baseURL: nil)
        forgotPasswordWebview.scrollView.isScrollEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        if DeviceType.iPhone5orSE {
            self.signinTable.contentOffset = CGPoint(x: 0, y:15)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
            cell.textField.keyboardType = UIKeyboardType.emailAddress
            cell.textField.placeholder = "Email/Mobile No"
            emailTextField = cell.textField
            cell.logoImageView.image = UIImage(named:"mail")!
            emailTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        else{
            cell.textField.returnKeyType = UIReturnKeyType.done
            cell.textField.placeholder = "Password"
            cell.textField.isSecureTextEntry = true
            passwordTextField = cell.textField
            cell.logoImageView.image = UIImage(named:"password")!
            passwordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
            
        }
        
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
      //  emailTextField.text  = "meena@gmail.com"
      //  cell.textField.text = "123456"
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    // MARK: Webview Delegate/////////////////////////////////////
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == .linkClicked
        {
            
            if webView.tag == 101 {
                // code for skip navigation

                
                let loginInfo :NSMutableDictionary =  NSMutableDictionary()
                    loginInfo.setValue("0.0", forKey: klatitude)
                    loginInfo.setValue("0.0", forKey: klongitude)
                    loginInfo.setValue("", forKey: klocality_id)
                    
                kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfo), forKey: kloginInfo)
                  
                
                appDelegate.userType  = kguestUser
                self.performSegue(withIdentifier: kTabbarSegueIdentifier, sender: nil)
            }
            else{
                // code for forgot password navigation
                
                print("forgotPassword")
                self.performSegue(withIdentifier: kForgotPasswordSegueIdentifier, sender: nil)
                
            }
            return false
        }
        return true
    }
    
    
    // MARK: - Button Action///////////////////////////////////
    @IBAction func signinButton_Clicked(_ sender: AnyObject) {
        
        register_type = "N"
        appDelegate.userType = "Normal"
        
        if validation() { // check sign in validation
            siginInAPI()
        }
    }
    
    // fb login
    @IBAction func facebookButton_clicked(_ sender: AnyObject) {
        
        register_type = "S"
        appDelegate.userType = "Social"

        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            showHude()
                            
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                
                                hideHude()
                                if (error == nil){
                                    let fbDict = result as! [String : AnyObject]
                                    let dict :NSMutableDictionary = NSMutableDictionary()
                                    
                                    if fbDict[kname] != nil{
                                    dict.setValue(fbDict[kname] as! NSString, forKey: kname)
                                    }
                                    
                                    if fbDict[kEmail] != nil{
                                    dict.setValue(fbDict[kEmail] as! NSString, forKey: kEmail)
                                    }
                                    
                                    if fbDict[kfirst_name] != nil {
                                    dict.setValue(fbDict[kfirst_name] as! NSString, forKey: kfirst_name)
                                    }
                                    if fbDict[klast_name] != nil{
                                      dict.setValue(fbDict[klast_name] as! NSString, forKey: klast_name)
                                    }

                                    
                                    if let imageURL = ((fbDict["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                                        dict.setValue(imageURL as NSString, forKey: kUrl)
                                    }
                                    self.socialDictionary = dict
                                    let id :NSString  = fbDict["id"] as! NSString
                                    
                                    self.checkUserExistance(type: "fb", socialID:id)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    // twitter login
    @IBAction func twitterButton_clicked(_ sender: AnyObject) {
        register_type = "S"
        appDelegate.userType = "Social"
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(String(describing: session?.userName))");
                
                let userId = session?.userID
                
                let dict :NSMutableDictionary = NSMutableDictionary()
                
                dict.setValue(userId, forKey: kid)
                dict.setValue(session?.userName, forKey: kname)
                self.socialDictionary = dict
                
                self.checkUserExistance(type: "twitter", socialID:userId! as NSString)
                
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
    }
    
    
    // google login
    @IBAction func googleButton_clicked(_ sender: AnyObject) {
        
        register_type = "S"
        appDelegate.userType = "Social"

        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        hideHude()
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID
            let fullName = user.profile.name
            let email = user.profile.email
            let image: String = user.profile.imageURL(withDimension: 80).absoluteString
            
            let dict :NSMutableDictionary = NSMutableDictionary()
            
            dict.setValue(userId, forKey: kid)
            dict.setValue(fullName, forKey: kname)
            dict.setValue(email, forKey: kemailId)
            dict.setValue(image, forKey: kUrl)
            self.socialDictionary = dict
            
            self.checkUserExistance(type: "gp", socialID:userId! as NSString)
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
        
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
    
    @IBAction func creatAccount_Button(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: kSignupSegueIdentifier, sender: nil)
    }
    
    
    // creat new account
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    
    
    // MARK - APIs Call
    
    func checkUserExistance(type: NSString,socialID:NSString){
        
        var params : NSMutableDictionary = [:]
        
        params = [
            kstype: type,
            kemailId : "",
            ksocialId :socialID
        ]
        
        self.socialDictionary.setValue(type, forKey: kstype)
        self.socialDictionary.setValue(register_type, forKey: kregister_type)
        self.socialDictionary.setValue(socialID, forKey: ksocialId)
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"socialLogin")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict    = response
                    let payload :NSMutableDictionary =  (dict![kPayload] as?NSMutableDictionary)!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"
                    {
                        var lat : String = ""
                        var lng : String  = ""
                        if (payload.value(forKey: klatitude) != nil){
                            lat = "0.0"
                        }
                        if (payload.value(forKey: klongitude) != nil){
                            lng = "0.0"
                        }
                        
                        payload.setValue(lat, forKey: klatitude)
                        payload.setValue(lng, forKey: klongitude)
                    
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:payload), forKey: kloginInfo)
                        self.performSegue(withIdentifier: kTabbarSegueIdentifier, sender: nil)
                        
                    }
                        
                    else if index == "400"
                    {
                        self.performSegue(withIdentifier: kSignupSegueIdentifier, sender: self.socialDictionary)
                    }
                    else
                    {
                        self.performSegue(withIdentifier: kSignupSegueIdentifier, sender: self.socialDictionary)
                        
                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
            
            
            
        }
        
    }
    
    
    func siginInAPI(){
        
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        var params : NSMutableDictionary = [:]
        
        params = [
            kloginId: emailTextField.text!,
            kpassword : passwordTextField.text!,
            kdeviceToken : appDelegate.deviceToken,
            kdeviceType : "i"
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"userlogin")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    
                    let dict    = response
                    let payload :NSMutableDictionary =  (dict![kPayload] as?NSMutableDictionary)!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200"
                    {
                        
                        var lat : String = ""
                        var lng : String  = ""
                        if (payload.value(forKey: klatitude) != nil){
                            lat = "0.0"
                        }
                        
                        if (payload.value(forKey: klongitude) != nil){
                            lng = "0.0"
                        }
                        
                        payload.setValue(lat, forKey: klatitude)
                        payload.setValue(lng, forKey: klongitude)
                        
                        
                        
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:payload), forKey: kloginInfo)
                   //     self.navigationController?.isNavigationBarHidden = false

                        self.performSegue(withIdentifier: kTabbarSegueIdentifier, sender: nil)
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
    
    
    func jsonToString(json: AnyObject){
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString as Any) // <-- here is ur string
            
        } catch let myJSONError {
            print(myJSONError)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // MARK - Validation
    
    func validation()-> Bool {
        
        if emailTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter valid email", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if  isValidEmail(testStr: emailTextField.text!) == false && !self.isNumber(stringToTest: emailTextField.text!){
            
            alertController(controller: self, title: "", message: "Please enter valid email", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
        else if passwordTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter Password.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }
    
    func isNumber(stringToTest : String) -> Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !stringToTest.isEmpty && stringToTest.rangeOfCharacter(from:numberCharacters) == nil
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kChangePasswordSegueIdentifier {
            let changePassword :ChangePasswordViewController = segue.destination as! ChangePasswordViewController
            changePassword.fromViewController = sender as! NSString
        }
            
        else if segue.identifier == kSignupSegueIdentifier{
            
            let  signUpViewController :SignupViewController = segue.destination as! SignupViewController
            
            signUpViewController.incommingType = "";
            
            
            if (self.socialDictionary != nil) {
                signUpViewController.incommingType = kSocialLogin as NSString;
                signUpViewController.socialDictionary = self.socialDictionary
                
            }
            
            
        }
        
    }
    
    
}
