//
//  TableCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 21/04/23.
//

import UIKit

class TableCell: UITableViewCell {

    @IBOutlet weak var background_View: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_View_Remarks: UITextView!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_More: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btn_More.setTitle("", for: .normal)
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
