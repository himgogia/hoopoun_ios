//
//  otherCartManualInputViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 24/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class otherCartManualInputViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var cardBannerImage: UIImageView!
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var cardNameTextField: UITextField!
    @IBOutlet var cardTypeLabel: UILabel!
    @IBOutlet var selectionView: UIView!
    
    @IBOutlet var nocardMessageLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var bannerImageButton: UIButton!

    
    @IBOutlet var cardTypeButton: UIButton!
    @IBOutlet var addcardButton: UIButton!
    
    let imagePicker = UIImagePickerController()

    
    var selectedcardDictionary : NSMutableDictionary!
    var loginInfoDictionary :NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary!
    
    var cardType :String = ""
    var fromViewType : String!
    
    var cardNumber : String = ""
    var cardName : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Other Loyalty Card"
        self.navigationController?.isNavigationBarHidden = false
        
//        cardBannerImage.layer.cornerRadius = 10.0
//        cardBannerImage.layer.borderWidth = 1.0
//        cardBannerImage.layer.borderColor = UIColor.lightGray.cgColor
//        cardBannerImage.layer.masksToBounds = true
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (cardBannerImage.image != nil) {
            editButton.isHidden = false
            bannerImageButton.isHidden = true
            nocardMessageLabel.isHidden = true
        }
        else{
            bannerImageButton.isHidden = false
            editButton.isHidden = true
            nocardMessageLabel.isHidden = false
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK -: Textfield Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == cardNumberTextField {
            cardNameTextField.becomeFirstResponder()
        }
        else if textField == cardNameTextField {
            cardNameTextField.resignFirstResponder()
        }
        return true
    }
    
    // MARK:- Button Clicked
    
    @IBAction func addCardtButton_Clicked(_ sender: Any) {
        
        if validation() {
            cardNameTextField.resignFirstResponder()
            cardNumberTextField.resignFirstResponder()
            
           self.addOthercard()
        }
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    
  
    @IBAction func cardTypeButton_clicked(_ sender: Any) {
        
        // Add card type picker
        let cardTypeArray = ["Barcode","QR code"]
        
        ActionSheetStringPicker.show(withTitle: "Select card Type", rows: cardTypeArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print(cardTypeArray[value])
            self.cardTypeLabel.text = cardTypeArray[value]
            self.cardTypeLabel.textColor = UIColor.black
            
            if value == 1 {
                self.cardType = "2"
            }
            else{
                self.cardType = "1"
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func editButton_Clicked(_ sender: Any) {
        
        self.setBannerImage()
    }
    
    
    
    // MARK:- Action sheet
    
    func setBannerImage(){
        
        //Create the AlertController and add Its action like button in Actionsheet
        
        
        let actionViewController: UIAlertController = UIAlertController(title: " Set Banner Image ", message: "", preferredStyle: .actionSheet)
        
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
        
        nocardMessageLabel.isHidden = true
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
            cardBannerImage.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            cardBannerImage.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if cardNumberTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter card number", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        else if cardNameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter name / description", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if cardNameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please select card type.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if cardTypeLabel.text == "Select card Type" && cardTypeLabel.text == "" && self.fromViewType != keditcard {
            
            alertController(controller: self, title: "", message: "Please select card type.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        else if (self.cardBannerImage.image == nil) {
            
            alertController(controller: self, title: "", message: "Please select card image", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }
    
    
    
    //MARK -: Add card APIs Call
    func addOthercard()
    {
        showHude()
        let url = NSURL(string: String(format: "%@%@",kBaseUrl,"addOtherCard"))!
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("close", forHTTPHeaderField: "Connection")
        
        let boundary = generateBoundaryString()
        
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (self.cardBannerImage.image == nil)
        {
            return
        }
        
        let image_data =  UIImageJPEGRepresentation(self.cardBannerImage.image!, 0.7)
        
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
        
        cardName = self.cardNameTextField.text!
        
     /*   // card_name
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"card_name\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(String(describing: cardName))\r\n".data(using: String.Encoding.utf8)!)*/
        
        
        // Description
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"description\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(cardName)\r\n".data(using: String.Encoding.utf8)!)
        
        cardNumber = self.cardNumberTextField.text!
        //card_no
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"card_no\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(cardNumber)\r\n".data(using: String.Encoding.utf8)!)
        
        //card_type_id
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"card_type_id\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\("1")\r\n".data(using: String.Encoding.utf8)!)
        
        /* //Industry
         body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
         body.append("Content-Disposition:form-data; name=\"Industry\"\r\n\r\n".data(using: String.Encoding.utf8)!)
         body.append("\("test")\r\n".data(using: String.Encoding.utf8)!)*/
        
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
                        
                        self.navigationController?.popToRootViewController(animated: true)
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
