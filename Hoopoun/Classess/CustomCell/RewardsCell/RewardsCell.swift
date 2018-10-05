//
//  RewardsCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 03/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class RewardsCell: UITableViewCell,UIScrollViewDelegate {

    @IBOutlet var offerTyeHeight: NSLayoutConstraint!
    @IBOutlet var offerAddressHeight: NSLayoutConstraint!
    @IBOutlet var offerBGViewHeight: NSLayoutConstraint!
    @IBOutlet var redeemedLabelWidth: NSLayoutConstraint!
    @IBOutlet var historyRedeemedLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerAddressLabel: UILabel!
    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var offerBGView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet var redeemLabelWidth: NSLayoutConstraint!
    @IBOutlet var redeemLabel: UILabel!
    var labelHeight : NSInteger = 32

//    @IBOutlet var offLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // ser border and corner radious of BG view
        offerBGView.layer.shadowColor = UIColor.lightGray.cgColor
        offerBGView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        offerBGView.layer.shadowRadius = 1.0
        offerBGView.layer.shadowOpacity = 0.5
        offerBGView.layer.cornerRadius = 5.0;
        offerBGView.layer.borderWidth = 1.0
        offerBGView.layer.borderColor = UIColor.lightGray.cgColor
        
        // set data label corner radious
        dateLabel.layer.cornerRadius = 12.0
        dateLabel.layer.masksToBounds = true
        
        // rating label
        ratingView.isUserInteractionEnabled = false
        ratingView.backgroundColor = UIColor.white

        // set image corner radious
        offerImage.layer.cornerRadius = 5.0
        offerImage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func redeemView(redeemCount : NSInteger, useRedeem : NSInteger){
        
        for v in self.scrollView.subviews{
            v.removeFromSuperview()
        }
        
        var x_axis : Float = 5.0

             for i in 1...redeemCount{
        
            let redeemButton : UIButton = UIButton()
            redeemButton.frame = CGRect(x:Int(x_axis), y: 3, width: 24, height: 24)
            redeemButton.backgroundColor = UIColor.clear
                
                if i <= useRedeem {
                      redeemButton.setImage(UIImage(named: "reedem"), for: UIControlState.normal)
                }
                else{
                  redeemButton.setImage(UIImage(named: "visit"), for: UIControlState.normal)
                }
          
            self.scrollView.addSubview(redeemButton)
            x_axis = x_axis+29

        }
        
        
        self.scrollView.contentSize = CGSize(width: Int(x_axis), height: 30)
    }
    
    // set data for reward cell
    func setCellData(dictionary:NSMutableDictionary){
        
        // date Label
        
        self.historyRedeemedLabel.isHidden = true
        self.redeemLabelWidth.constant = 0.0
        // show Redeem image
        
        dateLabel.text = String(format: "%@",(dictionary.value(forKey: kredeemDay) as? String)!)
        
        // rating
        let rating = dictionary.value(forKey: "storerating") as? String
        let ratingInFlot : Float =  Float(rating!)!

        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)

        
        let offetType : String = (dictionary.value(forKey: kofferTitle) as? String)!

        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@, %@",storeName,(dictionary.value(forKey: kLocality) as? String)!)
        
        self.setCellLabesHeight(offetType: offetType, address: address, maxHeight: 40)
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        
        // image
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kimage_name) as? String
        
        
        if imgName?.isEmpty == false{
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerImgFolderName)!,imgName!) as NSString
            
            imgUrl = imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
            
            if UIApplication.shared.canOpenURL(NSURL(string: imgUrl as String)! as URL) {
                let imageUrl : NSURL = NSURL(string: imgUrl as String)!
                
                self.offerImage.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "cartPlaceHolder"),options: [], completed: { (image, error, cacheType, imageURL) in
                    // Perform operation.
                    print(error as Any)
                })
            }
        }
        
        let totalRedeem : String = dictionary.value(forKey: ktotalOfferNo) as! String
        let useRedeem : String = dictionary.value(forKey: kusedOfferNo) as! String

        if Int(totalRedeem) != Int(useRedeem) {
            redeemLabelWidth.constant = 0.0
        }
        
        // redeem scroll view
        self.scrollView.delegate = self
        self.redeemView(redeemCount: NSInteger(totalRedeem)!, useRedeem: NSInteger(useRedeem)!)
        
    }
    
    
    // set data for history cell
    func setOfferHistoryCellData(dictionary:NSMutableDictionary){
        
        // date Label
        
        self.historyRedeemedLabel.isHidden = false
        self.offerBGViewHeight.constant = 210
        
        dateLabel.text = String(format: "%@",(dictionary.value(forKey: kredeemDay) as? String)!)
        
        // rating
        let rating = dictionary.value(forKey: "storerating") as? String
        let ratingInFlot : Float =  Float(rating!)!

        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)

        let offetType : String = (dictionary.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@, %@",storeName,(dictionary.value(forKey: kLocality) as? String)!)
        
       self.setCellLabesHeight(offetType: offetType, address: address, maxHeight: 0)
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        
        // image
        self.setImages(dictionary: dictionary)

        offerAddressLabel.isHidden = false
        self.redeemLabel.isHidden = true
    }
    
    // set data for favorites offer
    func setFavoritesOfferdata(dictionary:NSMutableDictionary){
        
        // hide header view
        self.headerViewHeight.constant = 10.0
        self.headerView.isHidden = true
        self.offerBGViewHeight.constant = 210
        
        self.historyRedeemedLabel.isHidden = true
        self.redeemLabelWidth.constant = 0.0
        
        // rating
        let rating = dictionary.value(forKey: "storerating") as? String
        let ratingInFlot : Float =  Float(rating!)!
        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!

        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)

        // offer title
        self.offerTypeLabel.text = dictionary.value(forKey: kofferTitle) as? String
        
        // offer address
        self.offerAddressLabel.text = String(format: "%@, %@",storeName,(dictionary.value(forKey: kLocality) as? String)!)
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        
        // image
        self.setImages(dictionary: dictionary)

        self.redeemLabel.isHidden = true
    }
    
    
    // Aroun Me cell Data And HotDeal Cell Data
    func setAroundMeCellData(dictionary:NSMutableDictionary, cellType: NSString){
    
        
        self.historyRedeemedLabel.isHidden = true
        self.redeemLabelWidth.constant = 0.0
        self.offerBGViewHeight.constant = 270
        self.headerViewHeight.constant = 0.0
        self.headerView.isHidden = true


        // rating
        let rating = dictionary.value(forKey: kratting) as? String
        let ratingInFlot : Float =  Float(rating!)!
//        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)
        

        // offer Type
        
        let offetType :String = (dictionary.value(forKey: kofferTitle) as? String)!
        
        // offer address
        var address = ""
        if cellType == "cardOffer" {
             address = String(format: "%@",(dictionary.value(forKey: kstoreAddress) as? String)!)
        }
        else{
        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        address = String(format: "%@, %@",storeName,(dictionary.value(forKey: kstoreAddress) as? String)!)
            
            
        }
        
     self.setCellLabesHeight(offetType: offetType, address: address, maxHeight: 0)
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        // image
        self.setImages(dictionary: dictionary)

        self.redeemLabel.isHidden = true
        self.dateLabel.isHidden = true
        
    }
    
    
    // set data for Search view controller
    func globalSearchData(dictionary:NSMutableDictionary){
        
        
        self.historyRedeemedLabel.isHidden = true
        self.redeemLabelWidth.constant = 0.0
         self.offerBGViewHeight.constant = 210
        
        // hide header view
        self.headerViewHeight.constant = 10.0
        self.headerView.isHidden = true
        
        // rating
        let rating = dictionary.value(forKey: "storerating") as? String
        let ratingInFlot : Float =  Float(rating!)!

        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)
        
      
        let offetType : String = (dictionary.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@, %@",storeName,(dictionary.value(forKey: kLocality) as? String)!)
        
self.setCellLabesHeight(offetType: offetType, address: address, maxHeight: 0)
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
       //
        
        self.setImages(dictionary: dictionary)
       
        self.redeemLabel.isHidden = true
    }

    // set my fav store offer
    func setMyFavOffer(dictionary:NSMutableDictionary){
        
        self.historyRedeemedLabel.isHidden = true
        self.redeemLabelWidth.constant = 0.0
        self.offerBGViewHeight.constant = 210
        self.headerViewHeight.constant = 0.0
        self.headerView.isHidden = true
        
        
        // rating
        let rating = dictionary.value(forKey: kratting) as? String
        let ratingInFlot : Float =  Float(rating!)!
        
        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = String(format: "%0.1f", ratingInFlot)
        
        let offetType : String = (dictionary.value(forKey: kofferTitle) as? String)!
        
        let storeName :String = (dictionary.value(forKey: kstore_name) as? String)!
        let address = String(format: "%@, %@",storeName,(dictionary.value(forKey: kstoreAddress) as? String)!)
        
      self.setCellLabesHeight(offetType: offetType, address: address, maxHeight: 0)
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        
        
        // image
        self.setImages(dictionary: dictionary)
        
        self.redeemLabel.isHidden = true
        self.dateLabel.isHidden = true
        
    }
    
    func setCellLabesHeight( offetType : String,address :String, maxHeight : CGFloat ){
        
        self.offerTypeLabel.text = offetType
        self.offerAddressLabel.text = address
        
        var cellHeight : CGFloat = 0.0
        let width = kIphoneWidth - 125
        
        var height  = offetType.height(withConstrainedWidth: width, font: UIFont(name: "SFUIText-Semibold", size: 12)!)
        
        if height > 30 {
            self.offerTyeHeight.constant = 30
            cellHeight = 30
        }
        else {
            self.offerTyeHeight.constant = CGFloat(height)
            cellHeight = CGFloat(height)
        }
        
        let addressWidth = kIphoneWidth - 135
        
        height =  address.height(withConstrainedWidth: addressWidth, font: UIFont(name: "SFUIText-Regular", size: 12)!)
        
        if height > 30 {
            self.offerAddressHeight.constant = 30
            cellHeight += 30
        }
        else {
            self.offerAddressHeight.constant = CGFloat(height)
            cellHeight += CGFloat(height)
        }
        self.offerBGViewHeight.constant = 215 + cellHeight + maxHeight
        

    }
    
    func setImages(dictionary : NSDictionary){
        
        // image
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let imagePath = dictionary.value(forKey: kimage_path) as? String
        let imgName  = dictionary.value(forKey: kimage_name) as? String
        
        
        if imgName?.isEmpty == false{
            
            var imgUrl : NSString = String(format:"%@%@/%@",imagePath!,(appdelegate?.offerImgFolderName)!,imgName!) as NSString
            
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

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
