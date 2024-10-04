//
//  ActivitySelectionTVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/08/24.
//

import UIKit

class ActivitySelectionTVC: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var selectionCurvedView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupUI() {
        titleLbl.setFont(font: .bold(size: .BODY))
        selectionCurvedView.layer.borderWidth = 1
        selectionCurvedView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.1).cgColor
        selectionCurvedView.layer.cornerRadius = 5
    }
}
