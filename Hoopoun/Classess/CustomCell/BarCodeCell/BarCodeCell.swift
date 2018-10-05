//
//  BarCodeCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 02/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class BarCodeCell: UITableViewCell {

    @IBOutlet var barcodeImage: UIImageView!
    @IBOutlet var barCodeLabel: UILabel!
    @IBOutlet var BGView: UIView!
    @IBOutlet var qrcodeImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    let codeGenerator = FCBBarCodeGenerator()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // barcode image corner radious
        self.BGView.layer.borderColor = UIColor(red: 237.0/255.0, green:
            237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
        self.BGView.layer.shadowColor = UIColor.lightGray.cgColor
        self.BGView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        self.BGView.layer.borderWidth = 1.0
        self.BGView.layer.cornerRadius = 10.0
        self.BGView.layer.shadowOpacity = 0.5
        
    }

    
    func setCodeData(dictionary : NSMutableDictionary){
        
        // collection cell for wallet
        
        // description
        
        if dictionary.value(forKey: kdescription) != nil {
            let description : String = (dictionary.value(forKey: kdescription) as? String)!
            self.descriptionLabel.text = description
        }
        
        
        let codeString : String = (dictionary.value(forKey: kcard_no) as? String)!
 
        let cardName: String = (dictionary.value(forKey: kcard_no) as? String)!
            self.barCodeLabel.text = cardName
        
        if (dictionary.value(forKey: kcard_type_id) != nil) {
            let cardType: String = (dictionary.value(forKey: kcard_type_id) as? String)!
            
            if cardType == "1" {
                if let image = codeGenerator.barcode(code: codeString, type: .code128, size: self.barcodeImage.frame.size) {
                    self.barcodeImage.image = image
                    self.qrcodeImage.isHidden = true
                }
            }
            else{
                if let image = codeGenerator.barcode(code: codeString, type: .qrcode, size: self.qrcodeImage.frame.size) {
                    self.barcodeImage.isHidden = true
                    self.qrcodeImage.image = image
                }
            }
            
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

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
