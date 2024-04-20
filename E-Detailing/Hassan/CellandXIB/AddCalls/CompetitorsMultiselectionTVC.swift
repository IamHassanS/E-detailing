//
//  CompetitorsMultiselectionTVC.swift
//  E-Detailing
//
//  Created by San eforce on 27/03/24.
//

import UIKit

class CompetitorsMultiselectionTVC: UITableViewCell {
    @IBOutlet var competitorProduct: UILabel!
    @IBOutlet var competitorCompany: UILabel!
    @IBOutlet var menuIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        competitorProduct.setFont(font: .bold(size: .BODY))
        competitorProduct.textColor = .appTextColor
        competitorCompany.setFont(font: .medium(size: .BODY))
        competitorCompany.textColor = .appLightTextColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
