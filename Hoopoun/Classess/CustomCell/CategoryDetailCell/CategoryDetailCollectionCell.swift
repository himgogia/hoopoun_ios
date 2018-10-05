//
//  CategoryDetailCollectionCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 30/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryDetailCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet var BGHeight: NSLayoutConstraint!
    @IBOutlet weak var offerAddressLabel: UILabel!
    //    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerBGView: UIView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet var offerTyeHeight: NSLayoutConstraint!
    @IBOutlet var offerAddressHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        offerImage.layer.borderWidth = 0.5
        offerBGView.layer.shadowColor = UIColor.lightGray.cgColor
        offerBGView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        offerBGView.layer.shadowRadius = 1.0
        offerBGView.layer.borderWidth = 1.0
        offerBGView.layer.borderColor = UIColor.lightGray.cgColor
        offerBGView.layer.shadowOpacity = 0.5
        offerBGView.layer.cornerRadius = 5.0;
        
        ratingView.isUserInteractionEnabled = false
        
        ratingView.backgroundColor = UIColor.white
        
        offerImage.layer.cornerRadius = 5.0;
        offerImage.layer.masksToBounds = true
        
        
    }
    
    func setCellData(offerAray:NSArray, index : NSInteger){
        
        let dictionary : NSMutableDictionary =  offerAray.object(at: index) as! NSMutableDictionary
        
        // rating
        let rating = dictionary.value(forKey: kratting) as? String
        let ratingInFlot : Float =  Float(rating!)!
        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)
        
        // offer title
        let offetType : String = (dictionary.value(forKey: kofferTitle) as? String)!
        
        let address: String = String(format: "%@, %@", (dictionary.value(forKey: kstore_name) as? String)!,(dictionary.value(forKey: kaddress) as? String)!)
        
        self.setCellLabesHeight(offetType: offetType, address: address, count: offerAray.count)
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        // image
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kimage_name) as? String
        self.offerImage.image = UIImage(named: "cartPlaceHolder")
        if imgName?.isEmpty == false  {
            
            let imgArray : NSArray = imgName!.components(separatedBy: ",") as NSArray
            
            if  imgArray.count > index{
                
                let filterImgName : String = (imgArray[index] as? String)!
                
                var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerImgFolderName)!,filterImgName) as NSString
                
                imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
                
                if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                    let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                    
                    self.offerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                        // Perform operation.
                        print(error as Any)
                        
                    })
                }
            } else{
                self.offerImage.image = UIImage(named: "cartPlaceHolder")
            }
        }
        
    }
    
    
    func setCellLabesHeight( offetType : String,address :String,count: NSInteger ){
        self.offerNameLabel.text = offetType
        self.offerAddressLabel.text = address

        let width = self.frame.size.width - 110
    
        var height  = offetType.height(withConstrainedWidth: width, font: UIFont(name: "SFUIText-Semibold", size: 12)!)
        
        if height > 30 {
         self.offerTyeHeight.constant = 30
        }
        else {
            self.offerTyeHeight.constant = CGFloat(height)
        }
        
        
        // offer address
        
        let addressWidth = self.frame.size.width - 130

        height =  address.height(withConstrainedWidth: addressWidth, font: UIFont(name: "SFUIText-Regular", size: 12)!)
        
        if height > 30 {
            self.offerAddressHeight.constant = 30
        }
        else {
            self.offerAddressHeight.constant = CGFloat(height)
        }
    }
    
}

//extension String {
//
//    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//        return ceil(boundingBox.height)
//    }
//
//    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//
//        return ceil(boundingBox.width)
//    }
//}
