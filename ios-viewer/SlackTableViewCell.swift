//
//  SlackTableViewCell.swift
//  ios-viewer
//
//  Created by Carter Luck on 2/17/18.
//  Copyright © 2018 brytonmoeller. All rights reserved.
//

import UIKit

class SlackTableViewCell: UITableViewCell {

    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var slackUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
