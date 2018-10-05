//
//  PhysicalcardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 29/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit



class PhysicalcardViewController: UIViewController,delegateScanBarCode {

    @IBOutlet var cameraView: UIView!
    @IBOutlet var barcodeBGView: UIView!
    
    @IBOutlet var cardBannerImage: UIImageView!
    @IBOutlet var cardNameTextField: UITextField!
    @IBOutlet var barcodeView: UIView!
    
    @IBOutlet var manualInputButton: UIButton!
    @IBOutlet var barcodeScanerButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var barCodeImage: UIImageView!
    @IBOutlet var barCodeLabel: UILabel!
    
    var loginInfoDictionary :NSMutableDictionary!
    

    let codeGenerator = FCBBarCodeGenerator()
    var selectedcardDictionary : NSMutableDictionary!
    
    var isScanCode : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // barcode image corner radious
//        cardBannerImage.layer.borderColor = UIColor.gray.cgColor
//        cardBannerImage.layer.borderWidth = 1.0
//        cardBannerImage.layer.cornerRadius = 0.0
//        cardBannerImage.layer.masksToBounds = true
        
        self.navigationItem.title = "Add Loyalty Card"
        
        self.setInitialData()
        
        loginInfoDictionary  = NSKeyedUnarchiver.unarchiveObject(with: kUserDefault.value(forKey: kloginInfo) as! Data) as! NSMutableDictionary
    }
    
    func setInitialData(){
        
        
        let imgUrl : String  = self.selectedcardDictionary.value(forKey: kcard_image) as! String
        
        if (NSURL(string: imgUrl) != nil) {
            
            self.cardBannerImage.sd_setImage(with: NSURL(string: imgUrl)! as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                // Perform operation.
                print(error as Any)
                
            })
        }
       
        

        
        if isScanCode == false {
            
            saveButton.isHidden = true
            cancelButton.isHidden = true
            manualInputButton.isHidden = false

            
            // set barcode button border
            barcodeScanerButton.layer.borderColor =  UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1).cgColor
            barcodeScanerButton.layer.borderWidth = 2.0
            barcodeScanerButton.layer.cornerRadius = 20.0
            barcodeScanerButton.layer.masksToBounds = true
            
        }
        else{
            
            barcodeBGView.isHidden = false
            manualInputButton.isHidden = true
            
            saveButton.isHidden = false
            cancelButton.isHidden = false
            
            // set barcode button border
      
            barcodeView.layer.borderColor = UIColor(red: 237.0/255.0, green:
                237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
            barcodeView.layer.shadowColor = UIColor.lightGray.cgColor
            barcodeView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
            barcodeView.layer.borderWidth = 1.0
            barcodeView.layer.cornerRadius = 10.0
            barcodeView.layer.shadowOpacity = 0.5
            
        }

    }
    
    
    // MARK :- Image Barcode
    class Barcode {
        
        class func fromString(string : String) -> UIImage? {
            
            let data = string.data(using: .ascii)
            let filter = CIFilter(name: "CICode128BarcodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            return UIImage(ciImage: (filter?.outputImage)!)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK:- Button Action
    
    @IBAction func scanButton_clicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: kcardScanneSegueIdentifier, sender: nil)
    }
    
    @IBAction func manualInputButton_Clicked(_ sender: Any) {
        
         self.performSegue(withIdentifier: kmanualInputSegueIdentifier, sender: self.selectedcardDictionary)
        
    }
    @IBAction func saveButton_Clicked(_ sender: Any) {
        
        if validation(){
            self.savecard()
        }
    }
    
    @IBAction func cancelButton_Clicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
     // function for get scan bar code
    func physicalBarCodeScan( string : String)
    {
        if let image = codeGenerator.barcode(code: string, type: .code128, size: barCodeImage.frame.size) {
                barCodeImage.image = image
        }
        
        barCodeLabel.text = string
        isScanCode = true
        self.setInitialData()
    
    }
    
    
    // MARK - Validation
    func validation()-> Bool {
        if cardNameTextField.text == "" {
            
            alertController(controller: self, title: "", message: "Please enter name / description", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
        
        return true;
    }
    
    //MARK -: Save card APIs Call
    
    func savecard(){
        
        // check user type
        
        let appDelegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate

        var  userID = ""
        var deviceID = ""
        
        if appDelegate.userType == kguestUser {
            deviceID =  appDelegate.getDeviceID()
        }
        else {
            userID = loginInfoDictionary[kid]! as! String
        }
        
        
        var params : NSMutableDictionary = [:]
        
        params = [
            "user_id": userID,
            "deviceId" : deviceID,
            kcard_name : "",
            kcard_type_id : "1",
            kcardRelatedToId : selectedcardDictionary[kcard_type_id] ?? "",
            kcard_no : barCodeLabel.text ?? "" ,
            kcard_type : "p",
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
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == kcardScanneSegueIdentifier {
            let scanViewController : barCodeScannerViewController = segue.destination as! barCodeScannerViewController
            scanViewController.fromViewController = kphysicalcard
            scanViewController.delegate = self
        }
        else  if segue.identifier == kmanualInputSegueIdentifier {
            let manualViewController = segue.destination as? AddManualcardViewController
            manualViewController?.fromViewType = ""
            manualViewController?.selectedcardDictionary = sender as? NSMutableDictionary
        }
    }
    

}
