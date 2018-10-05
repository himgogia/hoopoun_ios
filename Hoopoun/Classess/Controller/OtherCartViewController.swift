//
//  OthercardViewController.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class OthercardViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,delegateScanBarCode,UITextFieldDelegate {
    @IBOutlet var bannerImage: UIImageView!
    @IBOutlet var descriptionTextField: UITextField!
//    var cardNameTextField: UITextField!
    @IBOutlet var barcodeBGView: UIView!
    @IBOutlet var otherCartTableView: UITableView!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var manualButton: UIButton!
    
    @IBOutlet var editButton: UIButton!
    @IBOutlet var barcodeView: UIView!
    @IBOutlet var barcodeScanerButton: UIButton!
    @IBOutlet var bannerImageButton: UIButton!
    
    @IBOutlet var cameraView: UIView!

    @IBOutlet var barCodeImage: UIImageView!
    @IBOutlet var barCodeLabel: UILabel!
    @IBOutlet var nocardMessageLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    let codeGenerator = FCBBarCodeGenerator()
    
    var cardNumber : String = ""
    var isScanCode : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // barcode image corner radious
//        bannerImage.layer.borderColor = UIColor.gray.cgColor
//        bannerImage.layer.borderWidth = 1.0
//        bannerImage.layer.cornerRadius = 10.0
//        bannerImage.layer.masksToBounds = true
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
   
    self.setInitialData()
        
    self.navigationItem.title = "Add Other Loyalty Card"
        
    }
    
    func setInitialData(){
        
        if (bannerImage.image != nil) {
            editButton.isHidden = false
            bannerImageButton.isHidden = true
            nocardMessageLabel.isHidden = true
        }
        else{
            bannerImageButton.isHidden = false
            editButton.isHidden = true
            nocardMessageLabel.isHidden = false
        }
        
        if isScanCode == false {
            
            manualButton.isHidden = false
            saveButton.isHidden = true
            cancelButton.isHidden = true

            barcodeBGView.isHidden = true
            cameraView.isHidden = false

            // set barcode button border
            barcodeScanerButton.layer.borderColor =  UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1).cgColor
            barcodeScanerButton.layer.borderWidth = 2.0
            barcodeScanerButton.layer.cornerRadius = 20.0
            barcodeScanerButton.layer.masksToBounds = true
            
        }
        else{
            
            barcodeBGView.isHidden = false
            cameraView.isHidden = true
            manualButton.isHidden = true
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  /*  // MARK TableView Deleage ////////////////////////////////////////////
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isScanCode == true {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 0.001
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        let identifier = "cell"
        
        var cell: OtherCartCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? OtherCartCell
        
        tableView.register(UINib(nibName: "OtherCartCell", bundle: nil), forCellReuseIdentifier: identifier)
        cell = (tableView.dequeueReusableCell(withIdentifier: identifier) as? OtherCartCell)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.textField.delegate = self
        
        if indexPath.row == 0{
            cell.textField.keyboardType = UIKeyboardType.emailAddress
            cell.textField.placeholder = "Enter Name/Description"
            descriptionTextField = cell.textField
            
        }
        else{
            cell.textField.returnKeyType = UIReturnKeyType.done
            cell.textField.placeholder = "Cart Name"
            cardNameTextField = cell.textField
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }*/
    
    // MARK-: Button Clicked
    @IBAction func saveButtonClicked(_ sender: Any) {
        if isScanCode == true {
            
            if self.validation() == true {
                self.addOthercard()
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func manualButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "addOtherCartManualInputSegueIdentifier", sender: nil)

    }
    
    @IBAction func scanButton_clicked(_ sender: Any) {
        self.performSegue(withIdentifier: kcardScanneSegueIdentifier, sender: nil)
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
            let orientationFixedImage = image.fixOrientation()
            bannerImage.image = orientationFixedImage
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let orientationFixedImage = image.fixOrientation()
            bannerImage.image = orientationFixedImage
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
          nocardMessageLabel.isHidden = false
        
    }
    
    
    // MARK : - Barcode Delegate
    
    // function for get scan bar code
    func physicalBarCodeScan( string : String)
    {
        if let image = codeGenerator.barcode(code: string, type: .code128, size: barCodeImage.frame.size) {
            barCodeImage.image = image
        }
        
        barCodeLabel.text = string
        cardNumber = string
        isScanCode = true
        otherCartTableView.reloadData()
        self.setInitialData()
    }
    
    
    // MARK Button Action
    @IBAction func backButton_clicked(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
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
        
        if (self.bannerImage.image == nil)
        {
            return
        }
        
        let image_data =  UIImageJPEGRepresentation(self.bannerImage.image!, 0.7)
        
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
        

        
      /*  // card_name
         let cartName : String = (self.cardNameTextField.text)!

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"card_name\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(String(describing: cartName))\r\n".data(using: String.Encoding.utf8)!)*/
        
        
        // Description
        let cartDescription : String = self.descriptionTextField.text!

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"description\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(cartDescription)\r\n".data(using: String.Encoding.utf8)!)
        
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
    
    
    // MARK - Validation
    
    func validation()-> Bool {
        
        if descriptionTextField.text == "" {
            
            alertController(controller: self, title: "", message: "O", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            return false;
            
        }
//        else if  cardNameTextField.text == ""{
//
//            alertController(controller: self, title: "", message: "Please enter card number", okButtonTitle: "OK", completionHandler: {(index) -> Void in
//            })
//            return false;
//
//        }
       
        else if (self.bannerImage.image == nil) {
            
            alertController(controller: self, title: "", message: "Please select card image", okButtonTitle: "OK", completionHandler: {(index) -> Void in
            })
            
            return false;
        }
        
        
        return true;
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kcardScanneSegueIdentifier {
            let scanViewController : barCodeScannerViewController = segue.destination as! barCodeScannerViewController
            scanViewController.fromViewController = kphysicalcard
            scanViewController.delegate = self
        }

    }
    
    
    
}


extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
