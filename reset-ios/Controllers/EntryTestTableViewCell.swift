//
//  EntryTestTableViewCell.swift
//  reset-ios
//
//  Created by Anela Osmanovic on 30.08.18.
//  Copyright © 2018 Andza Os. All rights reserved.
//

import UIKit

class EntryTestTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCapacity: UILabel!
    @IBOutlet weak var imgChecked: UIImageView!
    @IBOutlet weak var btnDisenroll: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
