//
//  AddManualcardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


class AddManualcardViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet var cardBannerImage: UIImageView!
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var cardNameTextField: UITextField!
    @IBOutlet var cardTypeLabel: UILabel!
    @IBOutlet var selectionView: UIView!
    
    @IBOutlet var cardTypeButton: UIButton!
    @IBOutlet var addcardButton: UIButton!
    
    var selectedcardDictionary : NSMutableDictionary!
    var loginInfoDictionary :NSMutableDictionary!
    var  cardProviderDetailsDictionary : NSMutableDictionary!

    var cardType :String = ""
    var fromViewType : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
    
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        if self.fromViewType == keditcard {
            
            self.navigationItem.title = "Edit Loyalty Card"

            self.selectionView.isHidden = true
            self.addcardButton.setTitle("Save", for: UIControlState.normal)
            
            self.cardNameTextField.text = self.selectedcardDictionary.value(forKey: kdescription) as? String
            self.cardNumberTextField.text = self.selectedcardDictionary.value(forKey: kcard_no) as? String
            
            if self.selectedcardDictionary.value(forKey: kcard_type) != nil {
            let cardType: String = (self.selectedcardDictionary.value(forKey: kcard_type) as? String)!
            if cardType == "e"{
                cardNumberTextField.isUserInteractionEnabled = false
            }
            }
            
            
            // Add Delete Button
            let deleteButton : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
            deleteButton.titleLabel?.font = UIFont(name:"SFUIText-Medium", size: 15.0)
            deleteButton.setTitle("Delete", for: UIControlState.normal)
            deleteButton.tintColor = UIColor.white
            
            deleteButton.addTarget(self, action: #selector(deleteButton_Action), for: UIControlEvents.touchUpInside)
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: deleteButton), animated: true);
            
            // set banner image
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            
            let imagePath = cardProviderDetailsDictionary.value(forKey: kimage_path) as? String
            let imgName  = cardProviderDetailsDictionary.value(forKey: kimage_name) as? String
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.walletImgFolderName)!,imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.cardBannerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                    
                })
            }
        
        }
        else{
            
            self.navigationItem.title = "Add Manual Card"

            // set banner image
            let imgUrl  = self.selectedcardDictionary.value(forKey: kcard_image) as? String
            
            if (imgUrl != nil) {
                self.cardBannerImage.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: "cartPlaceHolder"))
            }
            
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
            
            if self.fromViewType == keditcard {
        
                self.editcard()
            }
            else{
                self.addcard()
            }
        }
    }
    
    @IBAction func backButton_Clicked(_ sender: Any) {
        
        if self.fromViewType == keditcard {
            
            self.navigationController?.isNavigationBarHidden = true
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.navigationController?.popViewController(animated: true)
}
        
    }
    
    func deleteButton_Action(){
    
        alertController(controller: self, title: "Are You Sure", message: "you want to delete this card?", okButtonTitle: "NO", cancelButtonTitle: "YES", completionHandler: {(index) -> Void in
            
            if index == 0 {
                self.deletecard()
            }
        })

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
    
    
    // MARK - Validation
    
    func validation()-> Bool {
      
        if cardNameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter  name / description.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
     else   if cardNumberTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter card number", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        
        else if cardTypeLabel.text == "Select card Type" && self.fromViewType != keditcard {
            
            alertController(controller: self, title: "", message: "Please select card type.", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        return true;
    }
    
    
    
    //MARK -: Add card APIs Call
    
    func addcard(){
        
        var params : NSMutableDictionary = [:]
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var  userID = ""
        var deviceID = ""
        
        if appDelegate.userType == kguestUser {
            deviceID =  appDelegate.getDeviceID()
        }
        else {
            userID = loginInfoDictionary[kid]! as! String
        }
        
        
        params = [
            "user_id": userID,
            "deviceId" : deviceID,
            kcard_name : "",
            kcard_type_id : self.cardType,
            kcardRelatedToId : selectedcardDictionary[kcard_type_id] ?? "",
            kcard_no : cardNumberTextField.text as Any,
            kcard_type : "p",
            kdescription : cardNameTextField.text ?? ""
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"AddCardOnWallet")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                    
                        print(dict[kPayload] as Any)
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message: message as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                    self.navigationController?.popToRootViewController(animated: true)
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
    
    func editcard(){
        
        var params : NSMutableDictionary = [:]
        
        params = [
            kid : selectedcardDictionary[kid]!,
            kcard_name : cardNameTextField.text as Any,
            kcard_no : cardNumberTextField.text as Any,
            kdescription : cardNameTextField.text as Any,
            "cardType" :  self.selectedcardDictionary.value(forKey: "type") as Any

        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"EditCardOnWallet")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        let message = dict[kMessage]

                        
                        alertController(controller: self, title: "", message:message as! String , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            self.navigationController?.popToRootViewController(animated: true)
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
    
    func deletecard(){
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var  userID = ""
        
        if appDelegate.userType == kguestUser {
            userID =  ""
        }
        else {
            userID = loginInfoDictionary[kid]! as! String
        }
        var params : NSMutableDictionary = [:]
        
        params = [
            "user_id": userID,
            "card_id" : self.selectedcardDictionary.value(forKey: kid) as Any,
            "cardType" :  self.selectedcardDictionary.value(forKey: "type") as Any
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"DeleteCardFromWallet")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        alertController(controller: self, title: "", message:dict[kMessage]! as! String , okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                            self.navigationController?.popToRootViewController(animated: true)
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
