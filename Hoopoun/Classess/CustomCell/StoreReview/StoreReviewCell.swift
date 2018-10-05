//
//  StoreReviewCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 15/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class StoreReviewCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var reviewImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var reviewView: FloatRatingView!
    @IBOutlet var reviewCountLabel: UILabel!
    @IBOutlet var reviewTextHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func setReviewCellData(dictionary:NSMutableDictionary){
    
        print(dictionary)
        
        self.viewBG.layer.masksToBounds = false
        self.viewBG.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewBG.layer.shadowOpacity = 0.5
        self.viewBG.layer.shadowOffset = CGSize.zero
        self.viewBG.layer.shadowRadius = 1
        self.viewBG.layer.cornerRadius = 5.0
        
        // name
        
        let  userName : String = (dictionary.value(forKey: kuserName) as? String)!
        self.nameLabel.text = userName.replacingOccurrences(of: "*", with: "")
        
        // create on
        
        self.dateLabel.text = dictionary.value(forKey: kcreated_on) as? String
        
        // review
        
        let reviewText = dictionary.value(forKey: kreview) as? String
        self.reviewLabel.text = reviewText
        
        let  height =  reviewText?.height(withConstrainedWidth: kIphoneWidth-85, font: UIFont(name: "SFUIText-Regular", size: 14)!)
        reviewTextHeight.constant = CGFloat(height!)
        
        
        // rating
        let rating = dictionary.value(forKey: "rating") as? String
        let ratingInFlot : Float =  Float(rating!)!
        
        self.reviewView?.rating = Double(ratingInFlot)
        self.reviewCountLabel?.text = String(format: "%0.1f", ratingInFlot)

        
        // image view
        reviewImage.layer.cornerRadius = reviewImage.frame.size.width/2
        reviewImage.layer.borderWidth = 1.5
        reviewImage.layer.borderColor = kLightBlueColor.cgColor
        reviewImage.layer.masksToBounds  = true
        
        let imgUrl  = dictionary.value(forKey: kuserImage) as? String
        
        if (imgUrl != nil) {
            self.reviewImage.sd_setImage(with: URL(string: imgUrl!), placeholderImage: UIImage(named: "userPlaceHolder"))
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
