//
//  CategoryOfferCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 14/10/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class CategoryOfferCell: UITableViewCell {

    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var offerLabelHeight: NSLayoutConstraint!
    @IBOutlet var offerLabel: UILabel!
    @IBOutlet var offerType: UILabel!
    @IBOutlet var offerTypeHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
