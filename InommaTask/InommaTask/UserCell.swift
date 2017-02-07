//
//  UserCell.swift
//  InommaTask
//
//  Created by Codefights on 2/6/17.
//  Copyright © 2017 Codefights. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
