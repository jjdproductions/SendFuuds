//
//  ProfileCell.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/11/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var publicButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var expirationLabel: UILabel!
    @IBOutlet weak var objectIdLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
