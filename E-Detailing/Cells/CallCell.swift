//
//  CallCell.swift
//  E-Detailing
//
//  Created by PARTH on 24/04/23.
//

import UIKit

class CallCell: UITableViewCell {

    @IBOutlet weak var pfp_View: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var btn_option: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        btn_option.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
