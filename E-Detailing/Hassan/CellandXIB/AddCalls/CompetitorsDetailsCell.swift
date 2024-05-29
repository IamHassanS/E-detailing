//
//  CompetitorsDetailsCell.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 26/03/24.
//

import UIKit

protocol CompetitorsDetailsCellDelagate : AnyObject {
    
    func didUpdateQuantity(qty: String, index: Int)
}

extension CompetitorsDetailsCell {

    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // Get the updated text after the replacement
//        let currentText = (textField.text ?? "") as NSString
//        let updatedText = currentText.replacingCharacters(in: range, with: string)
//
//        delegate?.didUpdateQuantity(qty: updatedText, index: index)
//   
//        
//        return true // Return true to allow the change
//    }
    
}


class CompetitorsDetailsCell: UITableViewCell, UITextFieldDelegate {
    

    
    @IBOutlet var compProductHolder: UIView!
    
    @IBOutlet var compProductLbl: UILabel!
    @IBOutlet var compCompanyLbl: UILabel!
    @IBOutlet var compCompanyHolder: UIView!
    @IBOutlet var valueHolder: UIView!
    
    @IBOutlet var valueLbl: UILabel!
    
    @IBOutlet var qtyHolde: UIView!
    
    @IBOutlet var qtyTF: UITextField!
    @IBOutlet var rateLbl: UILabel!
    @IBOutlet var rateHolder: UIView!
    @IBOutlet var deleteHolder: UIView!
    
    @IBOutlet var commentsHolder: UIView!
    @IBOutlet var commentsIV: UIImageView!
    weak var delegate: CompetitorsDetailsCellDelagate?
    
    var didCommentsAdded: Bool  = false {
        didSet {
            if didCommentsAdded  {
                commentsIV.tintColor = .appLightPink
            } else {
                commentsIV.tintColor = .appTextColor
            }
        }
    }
    
    var index: Int = 0
   // var productDetail: ProductDetails?
    
    var competitor : Competitor! {
        didSet {
            compProductLbl.text = competitor?.compProductName ?? ""
            compCompanyLbl.text = competitor?.compName ?? ""
        }
    }

    
    func setupUI() {

        qtyTF.delegate = self

    }
    
    @IBAction func didtapQtyLbl(_ sender: UITextField) {
        self.delegate?.didUpdateQuantity(qty: sender.text ?? "", index: index)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI() 
       // reloadTextField()
        let curvedViews : [UIView] = [compCompanyHolder, compProductHolder, rateHolder, valueHolder]
        
        curvedViews.forEach {
            $0.layer.cornerRadius = 3
            $0.backgroundColor = .appLightTextColor.withAlphaComponent(0.1)
        }
        
        qtyHolde.layer.borderWidth = 1
        qtyHolde.layer.cornerRadius = 3
        qtyHolde.layer.borderColor = UIColor.appLightTextColor.withAlphaComponent(0.2).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
