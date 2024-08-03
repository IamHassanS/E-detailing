//
//  FunEventsTVC.swift
//  E-Detailing
//
//  Created by San eforce on 25/05/24.
//

import UIKit

class FunEventsTVC: UITableViewCell {

    @IBOutlet var eventDate: UILabel!
    @IBOutlet var holderView: UIView!
    @IBOutlet var bgVXview: UIVisualEffectView!
    @IBOutlet var funDaysTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        funDaysTitle.setFont(font: .medium(size: .BODY))
        eventDate.setFont(font: .medium(size: .BODY))
        funDaysTitle.textColor = .appTextColor
        eventDate.textColor = .appTextColor
        holderView.layer.cornerRadius = 5
        bgVXview.backgroundColor = .appTextColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
