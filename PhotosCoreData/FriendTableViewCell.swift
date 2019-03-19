//
//  FriendTableViewCell.swift
//  PhotosCoreData
//
//  Created by Brock Gibson on 3/18/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendContactInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
