//
//  NoteCell.swift
//  NotesProject
//
//  Created by Codefights on 12/7/16.
//  Copyright © 2016 Codefights. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var noteNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
