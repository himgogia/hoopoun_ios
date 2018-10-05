//
//  EcardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 29/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class EcardViewController: UIViewController {
    
    @IBOutlet var BannerImage: UIImageView!
    @IBOutlet var barCodeImage: UIImageView!
    @IBOutlet var barcodeView: UIView!
    
    @IBOutlet var cardNameTextField: UITextField!
    
    @IBOutlet var barCodeLabel: UILabel!
    var selectedcardDictionary : NSMutableDictionary = NSMutableDictionary()

    
    var barCodeString: String  = ""


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get barcode image from QRCODE
        /* if let image = codeGenerator.barcode(code: barCodeString, type: .qrcode
         , size: barcodeView.frame.size) {
         
         barCodeImage.image = image
         }*/
        
       
        // barcode image corner radious
        BannerImage.layer.borderColor = UIColor.gray.cgColor
        BannerImage.layer.borderWidth = 1.0
        BannerImage.layer.cornerRadius = 10.0
        BannerImage.layer.masksToBounds = true
        
        // set borcode view border
        
        barcodeView.layer.cornerRadius = 10.0
        barcodeView.layer.borderWidth = 1.0
        barcodeView.layer.borderColor = UIColor.lightGray.cgColor
        barcodeView.layer.masksToBounds = true
       
        self.checkcarddetails()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Barcode {
        
        class func fromString(string : String) -> UIImage? {
            
            let data = string.data(using: .ascii)
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            return UIImage(ciImage: (filter?.outputImage)!)
        }
        
    }
    
    
    
    // MARK:- Button clicked
    @IBAction func saveButton_clicked(_ sender: Any) {
        if validation(){
            // save card
            self.savecard()
        }
    }
    
    @IBAction func cancelButton_clicked(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    // MARK - Validation
    func validation()-> Bool {
        if cardNameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Enter your card name", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        
        return true;
    }
    
    //MARK -: Save card APIs Call
    
    func savecard(){
        
       let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary

        
        var params : NSMutableDictionary = [:]
        
        params = [
            "user_id": loginInfoDictionary[kid]!,
            kcard_name : "",
            kcard_type_id : "1",
            kcardRelatedToId : selectedcardDictionary["cardRelatedToId"] ?? "",
            kcard_no : barCodeLabel.text ?? "" ,
            kcard_type : "e",
            kdescription : cardNameTextField.text ?? ""
        ]
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"AddCardOnWallet")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                       self.navigationController?.popToRootViewController(animated: true)
                        
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
    
    func checkcarddetails(){
        
          let loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var params : NSMutableDictionary = [:]
        
        // if user select current location
        if (appDelegate.lat == 0 && appDelegate.long == 0) {
            
            params = [
                klocality_id : appDelegate.locality_id,
                "user_id" : loginInfoDictionary.value(forKey: kid)!,
                "qrValue" : barCodeString
            ]
        }
        else{
            params = [
                
                klatitude: String(appDelegate.lat),
                klongitude: String(appDelegate.long),
                "user_id" : loginInfoDictionary.value(forKey: kid)!,
                 "qrValue" : barCodeString
            ]
        }
        
        print(params)
        
        let baseUrl = String(format: "%@%@",kBaseUrl,"qrCodeDetails")
        let requestURL: URL = URL(string: baseUrl)!
        NetworkManager.sharedInstance.postRequest(requestURL, hude: true, showSystemError: true, loadingText: false, params: params) { (response: NSDictionary?) in
            if (response != nil) {
                
                DispatchQueue.main.async {
                    print(response![kCode]!)
                    
                    let dict  = response!
                    let index :String = String(format:"%@", response![kCode]! as! CVarArg)
                    if index == "200" {
                        print(dict[kPayload] as Any)
                        
                        self.selectedcardDictionary = (dict[kPayload] as? NSMutableDictionary)!
                        
                        print(self.selectedcardDictionary)
                        
                            self.setInitialData(dict: self.selectedcardDictionary)
                        
                    }
                    else
                    {
                        let message = dict[kMessage]
                        
                        alertController(controller: self, title: "", message:message! as! String, okButtonTitle: "OK", completionHandler: {(index) -> Void in
                            
                        self.navigationController?.popViewController(animated: true)
                        })
                        
                    }
                }
            }
                
            else {
                
                // show alert
            }
            
            
            
            
        }
        
    }
    
    
    func setInitialData(dict : NSMutableDictionary){
    
        self.setImages(dictionary: dict)
        
        if (dict.value(forKey: "cardNo") != nil){
            let barcode :String  = dict.value(forKey: "cardNo") as! String
            
            barCodeImage.image = Barcode.fromString(string: barcode )
            barCodeLabel.text = barcode
        }
        
    }
    
    func setImages(dictionary : NSDictionary){
        
        // image
      //  let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
//        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kcard_image) as? String
        
        
        if imgName?.isEmpty == false{
            
            var imgUrl : NSString = String(format:"%@",imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.BannerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                })
            }
        }
        else{
            self.BannerImage.image = UIImage(named: "cartPlaceHolder")
        }
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
