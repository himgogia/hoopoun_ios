//
//  BusinessListCell.swift
//  Hoopoun
//
//  Created by vineet patidar on 04/11/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

import UIKit

class BusinessListCell: UITableViewCell {

    @IBOutlet var buttonTop: UIButton!
    @IBOutlet var textField: UITextField!
    @IBOutlet var arrowImages: UIImageView!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
