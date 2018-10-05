//
//  EditProfileViewController.swift
//  Hoopoun
//
//  Created by Chankit on 10/6/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EditProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Mark: Initalisation
    var fNameTextField : UITextField!
    var lNameTextField : UITextField!
    var mobileTextField : UITextField!
    var emailTextField : UITextField!
    var dobTextField : UITextField!
    var genderlabel :UILabel!
    var cityTextField : UITextField!
    var countryTextField : UITextField!
    var newsSwitch : UISwitch!
    var genderButton : UIButton!
    var dobButton : UIButton!
    var notificationSwitch : UISwitch!
    let imagePicker = UIImagePickerController()
    let GenderArray = ["Male","Female"]
    
    @IBOutlet var profileBGView: UIView!
    
    var loginInfoDictionary : NSMutableDictionary!
    var editProfileDictionary : NSMutableDictionary!
    
    // MARK: - Outlet //////////////////////////
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary

        setInitailLayout()
        
        if (self.editProfileDictionary != nil) {
        self.setProfile(detailDictionary: self.editProfileDictionary)
        }
        // Do any additional setup after loading the view.
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custome Function //////////////////////////
    
    /****************************
     * Function Name : - setInitailLayout
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - create layout
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    
    func setInitailLayout() -> Void {
        
        fNameTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        fNameTextField.backgroundColor = UIColor.clear
        fNameTextField.borderStyle = UITextBorderStyle.none
        fNameTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        fNameTextField.textColor = UIColor.white
        fNameTextField.delegate = self
        fNameTextField.textAlignment = .left
        fNameTextField.placeholder = "First name"
        
        lNameTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        lNameTextField.backgroundColor = UIColor.clear
        lNameTextField.borderStyle = UITextBorderStyle.none
        lNameTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        lNameTextField.textColor = UIColor.white
        lNameTextField.delegate = self
        lNameTextField.textAlignment = .left
        lNameTextField.placeholder = "Last name"
        
        mobileTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        mobileTextField.backgroundColor = UIColor.clear
        mobileTextField.borderStyle = UITextBorderStyle.none
        mobileTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        mobileTextField.textColor = UIColor.white
        mobileTextField.keyboardType = UIKeyboardType.phonePad
        mobileTextField.delegate = self
        mobileTextField.textAlignment = .left
        mobileTextField.placeholder = "Mobile Number"
        mobileTextField.isUserInteractionEnabled = false
        mobileTextField.text = ""
        
        emailTextField = UITextField(frame: CGRect(x: 20, y:10, width: kIphoneWidth-30, height: 30.00));
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.borderStyle = UITextBorderStyle.none
        emailTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        emailTextField.textColor = UIColor.white
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.delegate = self
        emailTextField.textAlignment = .left
        emailTextField.placeholder = "Email-Id"
//        emailTextField.isUserInteractionEnabled = false
        
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.none
        
        dobTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        dobTextField.backgroundColor = UIColor.clear
        dobTextField.borderStyle = UITextBorderStyle.none
        dobTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        dobTextField.textColor = UIColor.white
        dobTextField.isUserInteractionEnabled = false
        dobTextField.delegate = self
        dobTextField.textAlignment = .left
        dobTextField.placeholder = "DOB"
        
        cityTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        cityTextField.backgroundColor = UIColor.clear
        cityTextField.borderStyle = UITextBorderStyle.none
        cityTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        cityTextField.textColor = UIColor.white
        cityTextField.delegate = self
        cityTextField.textAlignment = .left
        cityTextField.placeholder = "City"
        
        countryTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-30, height: 30.00));
        countryTextField.backgroundColor = UIColor.clear
        countryTextField.borderStyle = UITextBorderStyle.none
        countryTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        countryTextField.textColor = UIColor.white
        countryTextField.delegate = self
        countryTextField.textAlignment = .left
        countryTextField.placeholder = "Country"
        
        genderlabel = UILabel(frame: CGRect(x: kIphoneWidth-150, y: 10, width: 130, height: 30))
        genderlabel.textAlignment = .right
        genderlabel.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        genderlabel.textColor = UIColor.white
        genderlabel.text = "Gender"
        
        genderButton = UIButton(frame: CGRect(x:kIphoneWidth-150 , y: 10, width: 130, height: 30))
        genderButton.backgroundColor = UIColor.clear
        genderButton.addTarget(self, action: #selector(genderButtonAction), for: UIControlEvents.touchUpInside)
        
        dobButton = UIButton(frame: CGRect(x:20 , y: 10, width: kIphoneWidth-200, height: 30))
        dobButton.backgroundColor = UIColor.clear
        dobButton.addTarget(self, action: #selector(dobButtonAction), for: UIControlEvents.touchUpInside)
        
        newsSwitch = UISwitch(frame: CGRect(x:kIphoneWidth-60 , y: 10, width: 130, height: 21))
        newsSwitch.isOn = false
        newsSwitch.setOn(true, animated: false)
        newsSwitch.addTarget(self, action: #selector(newsLetterButtonAction), for: .valueChanged)
        
        // notification switch
        notificationSwitch = UISwitch(frame: CGRect(x:kIphoneWidth-60 , y: 10, width: 130, height: 21))
        notificationSwitch.isOn = false
        notificationSwitch.setOn(true, animated: false)
        //notificationSwitch.addTarget(self, action: #selector(newsLetterButtonAction), for: .valueChanged)
        
        imagePicker.delegate = self
        
        // make profile image roundup
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.borderWidth = 3.0
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.masksToBounds = true
        
        profileBGView.layer.cornerRadius = profileBGView.frame.size.width/2
        profileBGView.layer.borderWidth = 3.0
        profileBGView.layer.borderColor = kBlueColor.cgColor
        profileBGView.layer.masksToBounds = true
        
    }
    
    /****************************
     * Function Name : - setProfile
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - set Profile Data
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func setProfile(detailDictionary: NSMutableDictionary) -> Void {
        let nameStr = detailDictionary .value(forKey: kname) as? String
        
        let fullNameArr : [String] = nameStr!.components(separatedBy: "*")
        if(fullNameArr.count>0)
        {
            fNameTextField.text = fullNameArr[0]
            
            if(fullNameArr.count>1)
            {
                lNameTextField.text = fullNameArr[1]
            }
        }
        
        mobileTextField.text = detailDictionary .value(forKey: kmobileNumber) as? String
        emailTextField.text = detailDictionary .value(forKey: kemailId) as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.date(from: (detailDictionary .value(forKey: kdob) as? String)!)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if (convertedDate != nil) {
            let date = dateFormatter.string(from: convertedDate!)
            dobTextField.text = date
        }
        else
        {
            dobTextField.text = ""
        }
        
        genderlabel.text = detailDictionary .value(forKey: kgender) as? String
        if(genderlabel.text=="")
        {
            genderlabel.text="Gender"
        }
        cityTextField.text = detailDictionary .value(forKey: kcity) as? String
        countryTextField.text = detailDictionary .value(forKey: kcountry) as? String
        if (detailDictionary .value(forKey: "newslatter_status") as? String == "0" )
        {
            newsSwitch.isOn = false;
        }
        else
        {
            newsSwitch.isOn = true;
        }
        
        
        // set profile image if existing
        
        if (loginInfoDictionary.value(forKey: kimage) != nil && (loginInfoDictionary.value(forKey: kimage) as? String)! != "") {
            let imageName : String = (loginInfoDictionary.value(forKey: kimage) as? String)!
            
            let imageUrl : NSURL = NSURL(string: imageName as String)!
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData:NSData = NSData(contentsOf: imageUrl as URL)!
                
                DispatchQueue.main.async {
                    self.profileImage.image = UIImage(data: imageData as Data)
                }
            }
        }
        
        profileTableView.reloadData()
        
    }
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if fNameTextField.text == "" && checkSpecialCharacter(string: (fNameTextField.text as? String)!)  {
            
            alertController(controller: self, title: "", message: "Enter first name.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
            
        else  if mobileTextField.text == "" {
            alertController(controller: self, title: "", message: "Enter Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
        else  if (mobileTextField.text!.characters.count != 10) {
            alertController(controller: self, title: "", message: "Enter valid Mobile No.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
        }
            
        else if emailTextField.text == "" {
            alertController(controller: self, title: "", message: "Enter your email.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if (!isValidEmail(testStr: emailTextField.text!)) {
            alertController(controller: self, title: "", message: "Enter your valid email.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
            
            
        else if dobTextField.text == "" {
            alertController(controller: self, title: "", message: "Enter your DOB.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if genderlabel.text == "" {
            alertController(controller: self, title: "", message: "Select your gender.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if genderlabel.text == "Gender" {
            alertController(controller: self, title: "", message: "Select your gender.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if cityTextField.text == "" {
            alertController(controller: self, title: "", message: "Enter your city.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if countryTextField.text == "" {
            alertController(controller: self, title: "", message: "Enter your city.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        dobTextField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        dobTextField.text = result
    }
    
    
    
    // MARK: - TableView Deleage //////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
      //  var sType :String = (self.editProfileDictionary.value(forKey: kstype) as? String)!
        
        //        sType = "fb"
        //
        //        if sType == "fb" {
        //           return 8
        //        }
        
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section>=0 && indexPath.section<7)
        {
            let identifier = "cell"
            var cell: editProfileCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? editProfileCell
            
            tableView.register(UINib(nibName: "editProfileCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? editProfileCell)!
            
            cell.selectionStyle  = .none
           cell.backgroundColor = UIColor.clear
            cell.textField.delegate = self
            
            if indexPath.section == 0{
                cell.addSubview(fNameTextField)
            }
            else if indexPath.section == 1{
                cell.addSubview(lNameTextField)
            }
            else if indexPath.section == 2{
                cell.addSubview(mobileTextField)
            }
            else if indexPath.section == 3{
                cell.addSubview(emailTextField)
            }
            else if indexPath.section == 4{
                cell.addSubview(dobTextField)
                
                cell.addSubview(dobButton)
                cell.addSubview(genderlabel)
                cell.addSubview(genderButton)
                
            }
            else if indexPath.section == 5{
                cell.addSubview(cityTextField)
            }
            else if indexPath.section == 6{
                cell.addSubview(countryTextField)
            }
            return cell
        }
            
        else
        {
            let identifier = "cell2"
            let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            cell.selectionStyle  = .none
            
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.textColor = UIColor.white;
            cell.textLabel?.font = UIFont(name: kFontSFUITextRegular, size: 14.0)
            
            
            
            if indexPath.section == 7{
                cell.textLabel?.text = "Newsletter Subscription"
                cell.addSubview(newsSwitch)
            }
            else if indexPath.section == 8{
                cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
                cell.textLabel?.text = "Change Password"
                
            }
            if indexPath.section == 9{
                cell.textLabel?.text = "Push Notification"
                cell.addSubview(notificationSwitch)
            }
            
           // cell.backgroundColor = kProfileLightBlueColor
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 8 {
            self.performSegue(withIdentifier: kChangePasswordSegueIdentifier, sender: nil)
        }
    }
    
    
    // creat new account
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fNameTextField {
            lNameTextField.becomeFirstResponder()
        }
        else if textField == lNameTextField{
            mobileTextField.becomeFirstResponder()
        }
        else if textField == mobileTextField{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField{
            dobTextField.becomeFirstResponder()
        }
        else if textField == dobTextField{
            cityTextField.becomeFirstResponder()
        }
        else if textField == cityTextField{
            countryTextField.becomeFirstResponder()
        }
        else if textField == countryTextField{
            countryTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
        
        if textField == fNameTextField && newLength>20{
            return false
        }
        else if textField == lNameTextField && newLength>20{
            return false
        }
        else if textField == mobileTextField && newLength>15{
            return false
        }
        else if textField == emailTextField && newLength>100{
            return false
        }
        else if textField == dobTextField && newLength>100{
            return false
        }
        else if textField == cityTextField && newLength>50{
            return false
        }
        else if textField == countryTextField && newLength>50{
            return false
        }
        return true
    }
    
    //Mark:- Button Action  ////////////////////////////
    
    /****************************
     * Function Name : - saveButton_Action
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - Save profile Button Action
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    @IBAction func saveButton_Action(_ sender: Any) {
        if validation()
        {
            updateProfile()
        }
    }
    
    /****************************
     * Function Name : - changeImageButton_Action
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - Change Button Button Action
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    @IBAction func changeImageButton_Action(_ sender: Any) {
        setProfileImage()
    }
    
    /*Navigation*/
    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    /****************************
     * Function Name : - dobButtonAction
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - Select DOB Button Action
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func dobButtonAction(sender: UIButton!) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var convertedDate = dateFormatter.date(from: self.dobTextField.text!)
        
        if convertedDate == nil {
            convertedDate =  Date()
        }
        
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: convertedDate, doneBlock: {
            picker, value, index in
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let date = dateFormatter.date(from: String(describing: value!))
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.dobTextField.text =   dateFormatter.string(from: date!)
            return
            
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        let secondsInWeek: TimeInterval = 365 * 70 * 24 * 60 * 60;
        let max: TimeInterval =  365 * 12 * 24 * 60 * 60;
        
        datePicker?.minimumDate = Date(timeInterval: -secondsInWeek, since: Date())
        datePicker?.maximumDate = Date()
        
       
       

        
        datePicker?.show()
    }
    
    
    
    /****************************
     * Function Name : - genderButtonAction
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - Change Gender Button Action
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func genderButtonAction(sender: UIButton!) {
        ActionSheetStringPicker.show(withTitle: "Select Gender", rows: GenderArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            //   print("value = \(value)")
            //   print("index = \(index)")
            // print("picker = \(picker)")
            
            self.genderlabel?.text = self.GenderArray[value]
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    /****************************
     * Function Name : - newsLetterButtonAction
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - news Letter Button Action
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func newsLetterButtonAction(sender:UISwitch!)
    {
        var status : String = ""
        if (sender.isOn == true){
            print("on")
            status = "1"
        }
        else{
            print("off")
            
            status = "0"
        }
        
        
        self.updateNewLatterStatus(status: status)
    }
    
    //Mark: API call
    
    /****************************
     * Function Name : - getProfile
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - get User Profile
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func getProfile(){
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String,
        ]
        
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,KmyProfile))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        let profileDictioary:NSMutableDictionary = dict[kPayload] as! NSMutableDictionary
                        self.setProfile(detailDictionary: profileDictioary)
                        
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
    
    /****************************
     * Function Name : - getProfile
     * Create on : - 9 oct 2017
     * Developed By : - Meenakshi
     * Description : - get User Profile
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func updateProfile(){
        
        
        let aStr = String(format: "%@*%@", fNameTextField.text!, lNameTextField.text!)
        
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String,
            kname : aStr,
            kmobileNumber : mobileTextField.text ?? "",
            kdob : dobTextField.text ?? "",
            kgender : genderlabel.text ?? "",
            kcity : cityTextField.text ?? "",
            kcountry : countryTextField.text ?? "",
            kemailId : emailTextField.text ?? ""
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,KupdateProfile))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(response![kPayload]!)
                        
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
    // MARK:- Action sheet
    
    func setProfileImage(){
        
        //Create the AlertController and add Its action like button in Actionsheet
        
        
        let actionViewController: UIAlertController = UIAlertController(title: " Set Profile ", message: "", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { _ in
            
            self.showImagePicker(type: 0)
        }
        actionViewController.addAction(galleryButton)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            
            self.showImagePicker(type: 1)
            
        }
        
        actionViewController.addAction(cameraButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        { _ in
        }
        
        actionViewController.addAction(cancelButton)
        self.present(actionViewController, animated: true, completion: nil)
    }
    
    
    
    
    // MARK:- Image Picker Controller
    
    func showImagePicker(type:NSInteger){
        
        if type == 1 {
            imagePicker.sourceType = .camera
        }
        else{
            imagePicker.sourceType = .photoLibrary;
            
        }
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = image
            
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = image
            
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        UploadRequest()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func UploadRequest()
    {
        showHude()
        let url = NSURL(string: String(format: "%@%@",kBaseUrl,KupdateProfileImage))!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("close", forHTTPHeaderField: "Connection")
        
        let boundary = generateBoundaryString()
        
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (profileImage.image == nil)
        {
            return
        }
        
        let image_data =  UIImageJPEGRepresentation(profileImage.image!, 0.7)
        
        if(image_data == nil)
        {
            return
        }
        
        
        let body = NSMutableData()
        
        
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        let filename = "imageName.jpeg"
        let userId = loginInfoDictionary[kid] as! String
        
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"userId\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(userId)\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"userfile\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--".appending(boundary.appending("--")).data(using: String.Encoding.utf8)!)
        
        request.httpBody =  body as Data
        let lenght = body.length
        request.setValue("\(lenght)", forHTTPHeaderField: "Content-Length")
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            DispatchQueue.main.sync {
                hideHude()
            }
            guard let _:NSData = data as? NSData, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            let dataString = String(data: data!, encoding: String.Encoding.utf8) as String!
            print(dataString ?? "")
            
            
            var dictonary:NSDictionary?
            
            do {
                dictonary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] as NSDictionary?
                
                if let myDictionary = dictonary
                {
                    let message = myDictionary[kMessage]
                    
                    alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        
                        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
                        
                        let imageUrl : String = (myDictionary[kPayload] as? String)!
                        loginInfoDictionary.setValue(imageUrl, forKey: kimage)
                        
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
                    })
                }
            } catch let error as NSError {
                print(error)
                alertController(controller: self, title: "", message:error.localizedDescription , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    
                })
            }
            
            
        }
        
        task.resume()
        
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    //Mark: API call
    
    /****************************
     * Function Name : - getProfile
     * Create on : - 15 Nov 2017
     * Developed By : - Ram
     * Description : - Update New latter Status
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func updateNewLatterStatus( status :String){
        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            "user_id" : loginInfoDictionary[kid] as! String,
            "status" : status
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"newslatterStatus"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        let message = dict[kMessage]
                        self.editProfileDictionary.setValue(status, forKey: "newslatter_status")
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kChangePasswordSegueIdentifier {
            let  changePassword : ChangePasswordViewController = (segue.destination as? ChangePasswordViewController)!
            changePassword.fromViewController = kchangePassword as NSString
        }
    }
}






