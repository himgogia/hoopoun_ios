//
//  RightNowCollectionCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 21/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class RightNowCollectionCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    
    let codeGenerator = FCBBarCodeGenerator()
    
    var isShowHude : Bool!


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // barcode image corner radious
        self.layer.borderColor = UIColor(red: 237.0/255.0, green:
            237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
    
    // collectio cell for right now
   func setDataForRightNowLocation(dictionary:NSMutableDictionary){
    
    self.nameLabel.text = dictionary.value(forKey: kcategories_name) as? String

    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate
    
    let imagePath = dictionary.value(forKey: kimage_path) as? String
    let imgName  = dictionary.value(forKey: kimage_name) as? String
    
    var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerSmallImgFolderName)!,imgName!) as NSString
    
    imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
    
    if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
        let imageUrl : NSURL = NSURL(string: imgUrl as String)!
        
        self.imageview.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
            // Perform operation.
            print(error as Any)
            
        })
    }
    
    print(dictionary)
    }
    
    
    // collection cell for wallet
    func setWalletData(dictionary:NSMutableDictionary){
        
        let codeString : String = (dictionary.value(forKey: kcard_no) as? String)!
        
        let cardName: String = (dictionary.value(forKey: "card_name") as? String)!
            self.nameLabel.text = cardName
        
        // set barcode image
        if (dictionary.value(forKey: kcard_type_id) != nil) {
            let cardType: String = (dictionary.value(forKey: kcard_type_id) as? String)!
            
            if cardType == "1" {
                if let image = codeGenerator.barcode(code: codeString, type: .code128, size: self.imageview.frame.size) {
                    self.imageview.image = image
                }
            }
            else{
                if let image = codeGenerator.barcode(code: codeString, type: .qrcode, size: self.imageview.frame.size) {
                    self.imageview.image = image
                }
            }
 
        }
        
        
        print(dictionary)
    }
    
    
    // collection cell for wallet
    func setWallet(dictionary:NSMutableDictionary){
        
        let cardName: String = (dictionary.value(forKey: kProgramName) as? String)!
        self.nameLabel.text = cardName
        
        // image
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kimage_name) as? String
        
        if imgName?.isEmpty == false{
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerSmallImgFolderName)!,imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.imageview.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                })
            }
        }
        else{
            self.imageview.image = UIImage(named: "cartPlaceHolder")
        }
   
        print(dictionary)
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
    
    

}
