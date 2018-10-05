//
//  AroundMeCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 22/08/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class AroundMeCell: UITableViewCell {

    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerAddressLabel: UILabel!
//    @IBOutlet weak var offerTypeLabel: UILabel!
    @IBOutlet weak var distanceLable: UILabel!
    @IBOutlet weak var offerNameLabel: UILabel!
    @IBOutlet weak var offerBGView: UIView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        offerImage.layer.borderWidth = 0.5
        offerBGView.layer.shadowColor = UIColor.lightGray.cgColor
        offerBGView.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        offerBGView.layer.shadowRadius = 1.0
        offerBGView.layer.shadowOpacity = 0.5
        offerBGView.layer.cornerRadius = 5.0;
        
        ratingView.isUserInteractionEnabled = false

        ratingView.backgroundColor = UIColor.white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCellData(dictionary:NSMutableDictionary){
        
        // offer sort address
        self.offerLabel.text = "\("Offers in") \("dictionary.value(forKey: kstoreAddress) as? String")"
        
        // address with name
        self.offerLabel.text = String(format: "Offers in %@", (dictionary.value(forKey: kstoreAddress) as? String)!)
//        self.offerTypeLabel.text = dictionary.value(forKey: kofferType) as? String
        
        // rating
        let rating = dictionary.value(forKey: kratting) as? String
        let ratingInFlot : Float =  Float(rating!)!

        self.ratingView.rating = Double(ratingInFlot)
        self.ratingLabel.text = dictionary.value(forKey: kratting) as? String

        // offer title
        self.offerNameLabel.text = dictionary.value(forKey: kofferTitle) as? String
        
        // offer address
        self.offerAddressLabel.text = String(format: "%@",(dictionary.value(forKey: kstoreAddress) as? String)!)
        
        // distance
        let floadDistance = dictionary.value(forKey: kdistance) as! String
        let distance : Float =  Float(floadDistance)!
        let distanceInDecimal = String(format: "%0.2f km", distance)
        self.distanceLable.text = distanceInDecimal
        

        // image
        let imgUrl  = dictionary.value(forKey: kofferImage) as? String

        if (imgUrl != nil) {
            self.offerImage.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: "cartPlaceHolder"))
        }
      
    }
}
