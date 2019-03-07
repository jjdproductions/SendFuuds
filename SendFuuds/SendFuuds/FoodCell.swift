//
//  FoodCell.swift
//  SendFuuds
//
//  Created by Justin Leong on 3/6/19.
//  Copyright © 2019 JoshTav. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
