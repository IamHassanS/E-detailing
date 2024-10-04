//
//  OutboxCell.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/04/23.
//

import UIKit

class OutboxCell: UITableViewCell {

    @IBOutlet weak var background_Cell: UIView!
    @IBOutlet weak var pfp_image: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_Option: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
