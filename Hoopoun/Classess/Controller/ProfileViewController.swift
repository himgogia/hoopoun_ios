//
//  ProfileViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 17/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlet
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var confirmPasswordTextField : UITextField!
    let imagePicker = UIImagePickerController()
    
    var incommingType : NSString!
    var socialDictionary: NSDictionary = NSDictionary()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer.masksToBounds = true;
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false

        
        if self.incommingType   == kSocialLogin as NSString {
            
            if (self.socialDictionary.value(forKey: kUrl) != nil) {

                let imageUrl =  self.socialDictionary[kUrl] as! String
                
                self.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "NoImage"),options: [], completed: { (image, error, cacheType, imageURL) in
                    if image != nil {
                        self.UploadRequest()
                    }
                })
            }
            
            
        }
        
    }
    
    
    // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
        
        if indexPath.section == 0 {
            
            cell.textField.keyboardType = UIKeyboardType.emailAddress
            cell.textField.placeholder = "Email"
            emailTextField = cell.textField
            cell.logoImageView.image = UIImage(named:"mail")!
             emailTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        else if indexPath.section == 1 {
            
            cell.textField.isSecureTextEntry = true
            cell.textField.placeholder = "Enter New Password"
            passwordTextField = cell.textField
            cell.logoImageView.image = UIImage(named:"password")!
             passwordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        else  if indexPath.section == 2 {
            cell.textField.returnKeyType = UIReturnKeyType.done
            cell.textField.isSecureTextEntry = true
            
            cell.textField.placeholder = "Confirm New Password"
            confirmPasswordTextField = cell.textField
            cell.logoImageView.image = UIImage (named :"password")
             confirmPasswordTextField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        }
        
        if self.incommingType == kSocialLogin as NSString {
        
            if ((self.socialDictionary["email"] as? String) != nil) {
                let email = self.socialDictionary["email"] as! String
                emailTextField.text = email
            }
        }
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
    // MARK: - TextField Delegate //////////////////////////
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField{
            confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField{
            confirmPasswordTextField.resignFirstResponder()
        }
        return true
    }
    
    
    
    // MARK: - Button Action
    
    @IBAction func profileButton_clicked(_ sender: AnyObject) {
        setProfileImage()
    }
    
    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func submitButton_Clicked(_ sender: AnyObject) {
        
        if validation() == true {
            register()
            
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
            profileImage.image = image.resizeWithWidth(width: 80)
        } else{
            
            print("Something went wrong")
        }
        
        
        
        self.UploadRequest()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)

    }
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if emailTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter  Email Id.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if  isValidEmail(testStr: emailTextField.text!) == false{
            
            alertController(controller: self, title: "", message: "Please enter valid Email Id.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if passwordTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter Password.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if confirmPasswordTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter Confirm Password.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if passwordTextField.text != confirmPasswordTextField.text {
            
            alertController(controller: self, title: "", message: "Password and Confirm Password must be same.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }
    
    
    
    // MARK:- APIS Call
    func register(){
        
        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary

        
        
        // param dictionary
        var params : NSMutableDictionary = [:]
        params = [
            kid : loginInfoDictionary[kid] as! String,
            kemailId : emailTextField.text!,
            kconfirmPassword : passwordTextField.text!,
            knewPassword : confirmPasswordTextField.text!
        ]
        
        print(params)
        
     
        let baseUrl = String(format: "%@%@",kBaseUrl,"setProfile")
        
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        
                        print(response![kPayload]!)
                    self.performSegue(withIdentifier: kTabbarSegueIdentifier, sender: nil)
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
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
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
                   
                   
                    let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
                    
                    let imageUrl : String = (myDictionary[kPayload] as? String)!
                    loginInfoDictionary.setValue(imageUrl, forKey: kimage)
                    kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
                  /*
                      let message = myDictionary[kMessage]
                     alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                        
                        let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
                        
                        let imageUrl : String = (myDictionary[kPayload] as? String)!
                        loginInfoDictionary.setValue(imageUrl, forKey: kimage)
                        
                        kUserDefault.set(NSKeyedArchiver.archivedData(withRootObject:loginInfoDictionary), forKey: kloginInfo)
                    })*/
                }
            } catch let error as NSError {
                print(error)
                alertController(controller: self, title: "", message:error.localizedDescription , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    
                })
            }
            
            
        }
        
        task.resume()
        
        
    }


    
//    extension NSMutableData {
//        
//        func appendString(string: String) {
//            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//            append(data!)
//        }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
}
}
