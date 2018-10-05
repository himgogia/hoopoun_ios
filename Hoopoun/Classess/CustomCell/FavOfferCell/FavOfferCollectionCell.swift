

//
//  FavOfferCollectionCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 22/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit


class FavOfferCollectionCell: UICollectionViewCell {
   
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerAddressLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var ratingBGView: UIView!
    @IBOutlet var BGView: UIView!
    @IBOutlet var offerAddressHeight: NSLayoutConstraint!
    @IBOutlet var offerLabelHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        ratingBGView.layer.borderColor = UIColor.lightGray.cgColor
//        ratingBGView.layer.shadowColor = UIColor.lightGray.cgColor
//       ratingBGView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        ratingBGView.layer.borderWidth = 1.0
        ratingBGView.layer.cornerRadius = 3.0
//        ratingBGView.layer.shadowOpacity = 0.5
        
        // set image corner radious
        offerImage.layer.cornerRadius = 5.0
        offerImage.layer.masksToBounds = true
    
        // barcode image corner radious
//        self.layer.borderColor = UIColor(red: 237.0/255.0, green:
//            237.0/255.0, blue: 237.0/255.0, alpha: 1.0).cgColor
//        self.layer.shadowColor = UIColor.red.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
//        self.layer.borderWidth = 1.0
//        self.layer.cornerRadius = 10.0
//        self.layer.shadowOpacity = 0.5
    }
    
    // set data for reward cell
    func setCellData(dictionary:NSMutableDictionary){
        
        
        // rating
        let rating = dictionary.value(forKey: "storerating") as? String
        let storeName = dictionary.value(forKey: kstore_name) as? String
        let ratingInFlot : Float =  Float(rating!)!
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)
        
        // offer address
        let address : String = String(format: "%@, %@",storeName!,(dictionary.value(forKey: kLocality) as? String)!)
        self.offerAddressLabel.text = address

        var height :Float = Float(calculateHeightForlblTextWithFont(address, _width: (kIphoneWidth-30)/2, font: UIFont(name: "SFUIText-Regular", size: 12)!))
        if  height > 36 {
            self.offerAddressHeight.constant = 36
        }
//        else{
//            self.offerAddressHeight.constant = CGFloat(height)
//        }
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = "hoopoun"
        
        // offer name
        let offerName : String = (dictionary.value(forKey: kofferTitle) as? String)!
         height  = Float(calculateHeightForlblTextWithFont(offerName, _width: (kIphoneWidth-30)/2, font: UIFont(name: "SFUIText-Bold", size: 13)!))
        if height > 40{
            self.offerLabelHeight.constant  = 40
        }
//        else{
//            self.offerLabelHeight.constant  = CGFloat(height)
//        }
         self.offerLabel.text = offerName
        
        // image
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kimage_name) as? String
        
        if imgName?.isEmpty == false{
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerSmallImgFolderName)!,imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.offerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                })
            }
        }
        else{
            self.offerImage.image = UIImage(named: "cartPlaceHolder")
        }
    }
    
}
