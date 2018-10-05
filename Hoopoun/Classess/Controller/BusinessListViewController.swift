//
//  BusinessListViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 04/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


class BusinessListViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var businessTable: UITableView!

    var appDelegate:AppDelegate! = nil
    
    
    let imagePicker = UIImagePickerController()
    
    //Mark: Initalisation
    var businessCategoryTextField : UITextField!
    var businessName : UITextField!
    var stateTextField : UITextField!
    var cityTextField : UITextField!
    var addressTextField : UITextField!
    
    var loginInfoDictionary : NSMutableDictionary!
    
    var businesscategoryArray : NSMutableArray = NSMutableArray()
    var cityArray : NSMutableArray = NSMutableArray()
    var stateArray : NSMutableArray = NSMutableArray()
    
    var selecteCategoryId : String = ""
    var selecteCityId : String = ""
    var selecteStateId : String = ""
    
    var isStateSelected : Bool = false
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        if appDelegate.userType == kguestUser {
            
            businessTable.isHidden = true
            alertController(controller: self, title: "", message: "Please Login first for being a business member of Hoopoun", okButtonTitle: "LOGIN", cancelButtonTitle: "CANCEL", completionHandler: {(index) -> Void in
                
                if index == 1 {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let signIn = storyBoard.instantiateViewController(withIdentifier: kSignInStoryBoardID) as? SignInViewController
                    let nav : UINavigationController = UINavigationController(rootViewController: signIn!)
                    self.appDelegate.window?.rootViewController = nav
                    self.appDelegate.window?.makeKeyAndVisible()                  }
                else{
                self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else{
            businessTable.isHidden = false
            self.getBusinessCaregory()
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        self.setInitailLayout()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            let window = UIApplication.shared.keyWindow!
            let addReviewButton = window.viewWithTag(2017)
            addReviewButton?.isHidden = true
        }
    }
    
    /****************************
     * Function Name : - setInitailLayout
     * Create on : - 4 Nov 2017
     * Developed By : - Ram
     * Description : - create layout
     * Organisation Name :- Sirez
     * version no :- 1.0
     ****************************/
    func setInitailLayout() -> Void {
        
        // business Category
        businessCategoryTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-70, height: 30.00));
        businessCategoryTextField.backgroundColor = UIColor.clear
        businessCategoryTextField.borderStyle = UITextBorderStyle.none
        businessCategoryTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        businessCategoryTextField.textColor = UIColor.black
        businessCategoryTextField.delegate = self
        businessCategoryTextField.textAlignment = .left
        businessCategoryTextField.isUserInteractionEnabled = false
        businessCategoryTextField.placeholder = "Select Business Category"
        
        // Busines Name
        businessName = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-70, height: 30.00));
        businessName.backgroundColor = UIColor.clear
        businessName.borderStyle = UITextBorderStyle.none
        businessName.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        businessName.textColor = UIColor.black
        businessName.delegate = self
        businessName.textAlignment = .left
        businessName.placeholder = "Enter Business Name"
        
        // state name
        stateTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-70, height: 30.00));
        stateTextField.backgroundColor = UIColor.clear
        stateTextField.borderStyle = UITextBorderStyle.none
        stateTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        stateTextField.textColor = UIColor.black
        stateTextField.delegate = self
        stateTextField.textAlignment = .left
        stateTextField.isUserInteractionEnabled = false
        stateTextField.placeholder = "Select State"
        
        // city name
        cityTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-70, height: 30.00));
        cityTextField.backgroundColor = UIColor.clear
        cityTextField.borderStyle = UITextBorderStyle.none
        cityTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        cityTextField.textColor = UIColor.black
        cityTextField.delegate = self
        cityTextField.textAlignment = .left
        cityTextField.isUserInteractionEnabled = false
        cityTextField.placeholder = "Select City"
        
        // address
        addressTextField = UITextField(frame: CGRect(x: 20, y: 10, width: kIphoneWidth-70, height: 30.00));
        addressTextField.backgroundColor = UIColor.clear
        addressTextField.borderStyle = UITextBorderStyle.none
        addressTextField.font =  UIFont(name: kFontSFUITextRegular, size: 14.0)
        addressTextField.textColor = UIColor.black
        addressTextField.delegate = self
        addressTextField.textAlignment = .left
        addressTextField.placeholder = "Add Address"
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "cell"
        
        var cell: BusinessListCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? BusinessListCell
        
        tableView.register(UINib(nibName: "BusinessListCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? BusinessListCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.textField.removeFromSuperview()
        cell.arrowImages.isHidden = false
        
        
        if indexPath.row == 0{
            cell.contentView.addSubview(businessCategoryTextField)
        }
        else if indexPath.row == 1{
            cell.contentView.addSubview(businessName)
            cell.arrowImages.isHidden = true
            
        }
        else if indexPath.row == 2{
            cell.contentView.addSubview(stateTextField)
            
            
        }
        else if indexPath.row == 3{
            cell.contentView.addSubview(cityTextField)
        }
        else if indexPath.row == 4{
            cell.contentView.addSubview(addressTextField)
            cell.arrowImages.isHidden = true
        }
        
        cell.buttonTop.tag = indexPath.row
        cell.buttonTop.addTarget(self, action:#selector(topButton_clicked), for: .touchUpInside)
        
        if isStateSelected == false && indexPath.row == 3 {
            cell.isHidden = true
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isStateSelected == false && indexPath.row == 3 {
            return 0
        }
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    // MARK Button Action
    @IBAction func backButton_clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraButton_clicked(_ sender: Any) {
        
        self.setProfileImage()
    }
    
    func topButton_clicked(sender :UIButton ){
        
        // Business Category
        if sender.tag == 0 {
            let array = self.businesscategoryArray.value(forKey: kcategories_name)
            
            ActionSheetStringPicker.show(withTitle: "Select Category", rows: array as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                
                print(self.businesscategoryArray[value])
                
                let dict : NSMutableDictionary = (self.businesscategoryArray[value] as? NSMutableDictionary)!
                
                self.businessCategoryTextField.text = dict.value(forKey: kcategories_name) as? String
                self.selecteCategoryId = (dict.value(forKey: kid) as? String)!
                
            }, cancel: { ActionStringCancelBlock in return }, origin:sender)
        }
            
            // city
        else  if sender.tag == 2 {
            
            let array = self.stateArray.value(forKey: kname)
            
            self.cityTextField.text = ""
            self.selecteCityId = ""
            ActionSheetStringPicker.show(withTitle: "Select State", rows: array as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                
                print(self.stateArray[value])
                
                let dict : NSMutableDictionary = (self.stateArray[value] as? NSMutableDictionary)!
                
                self.stateTextField.text = dict.value(forKey: kname) as? String
                self.selecteStateId = (dict.value(forKey: kid) as? String)!
                
                self.getCityList()
                
                
            }, cancel: { ActionStringCancelBlock in return }, origin:sender)
        }
            
        else if sender.tag == 3 {
            let array = self.cityArray.value(forKey: kname)
            
            
            ActionSheetStringPicker.show(withTitle: "Select city", rows: array as! [Any], initialSelection: 0, doneBlock: {
                picker, value, index in
                
                print(self.cityArray[value])
                
                let dict : NSMutableDictionary = (self.cityArray[value] as? NSMutableDictionary)!
                
                self.cityTextField.text = dict.value(forKey: kname) as? String
                self.selecteCityId = (dict.value(forKey: kid) as? String)!
                
            }, cancel: { ActionStringCancelBlock in return }, origin:sender)
        }
        
        
    }
    
    
    @IBAction func submitButton_clicked(_ sender: Any) {
        
        if self.validation() == true {
            
            self.businessName.resignFirstResponder()
            self.addressTextField.resignFirstResponder()
            
            self.submitBusinessListingData()
        }
    }
    
    
    // MARK:- Action sheet
    
    func setProfileImage(){
        
        //Create the AlertController and add Its action like button in Actionsheet
        
        
        let actionViewController: UIAlertController = UIAlertController(title: "Select Store Image ", message: "", preferredStyle: .actionSheet)
        
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
            imgView.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgView.image = image
        } else{
            print("Something went wrong")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK :- APIs call
    
    
    // business category
    func getBusinessCaregory(){
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"businessCategoryList"))!
        
        NetworkManager.sharedInstance.getRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: Dictionary?) in
            
            if response?.isEmpty == false {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200" {
                        
                        self.businesscategoryArray = (response?[kPayload] as?NSMutableArray)!
                        
                        self.getStateList()
           
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
    
    // State
    func getStateList(){
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"stateList"))!
        
        NetworkManager.sharedInstance.getRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: Dictionary?) in
            
            if response?.isEmpty == false {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    
                    if index == "200" {
                        
                        self.stateArray = (response?[kPayload] as?NSMutableArray)!
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
    
    func getCityList(){
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : self.selecteStateId
        ]
        
        let requestURL: URL = URL(string: String(format: "%@%@",kBaseUrl,"cityList"))!
        
        NetworkManager.sharedInstance.postRequest(requestURL, hude: false, showSystemError: false, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        self.cityArray = (response?[kPayload] as?NSMutableArray)!
                        
                        self.isStateSelected = true
                        self.businessTable.reloadData()
                        
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
    
    
    
    
    func submitBusinessListingData()
    {
        showHude()
        let url = NSURL(string: String(format: "%@%@",kBaseUrl,"businessListingForUser"))!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("close", forHTTPHeaderField: "Connection")
        
        let boundary = generateBoundaryString()
        
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (imgView.image == nil)
        {
            return
        }
        
        let image_data =  UIImageJPEGRepresentation(imgView.image!, 0.2)
        
        if(image_data == nil)
        {
            return
        }
        
        let body = NSMutableData()
        
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        let filename = "imageName.jpeg"
        let userId = loginInfoDictionary[kid] as! String
        
        
        // User id
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"user_id\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(userId)\r\n".data(using: String.Encoding.utf8)!)
        
        // businessCategory
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"businessCategory\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(self.selecteCategoryId)\r\n".data(using: String.Encoding.utf8)!)
        
        //businessName
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"businessName\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(String(self.businessName.text!) ?? "")\r\n".data(using: String.Encoding.utf8)!)
        
        //stateId
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"stateId\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(self.selecteStateId)\r\n".data(using: String.Encoding.utf8)!)
        
        //cityId
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"cityId\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(self.selecteCityId)\r\n".data(using: String.Encoding.utf8)!)
        
        //address
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"address\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(String(self.addressTextField.text!) ?? "")\r\n".data(using: String.Encoding.utf8)!)
        
        // image
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
                        
                        self.navigationController?.popViewController(animated: true)
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
    
    
    
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if businessCategoryTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please select business category", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if  businessCategoryTextField.text == ""{
            
            alertController(controller: self, title: "", message: "Please enter business name", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if stateTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please select state", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if cityTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please select city", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if addressTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter address", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if (self.imgView.image == nil) {
            
            alertController(controller: self, title: "", message: "Please select store image", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        
        return true;
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
