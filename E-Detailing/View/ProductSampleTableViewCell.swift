//
//  ProductSampleTableViewCell.swift
//  E-Detailing
//
//  Created by SANEFORCE on 11/08/23.
//

import UIKit


class ProductSampleTableViewCell : UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    
   
    @IBOutlet weak var txtProductCount: UITextField!
    
    @IBOutlet weak var txtSampleQty: UITextField!
    @IBOutlet weak var txtRxQty: UITextField!
    @IBOutlet weak var txtRcpaQty: UITextField!
    
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnDeviation: UIButton!
    
    
    
    @IBOutlet weak var viewStock: UIView!
    @IBOutlet weak var viewSample: UIView!
    @IBOutlet weak var viewRxQty: UIView!
    @IBOutlet weak var viewRcpa: UIView!
    
    @IBOutlet weak var viewDeviation: UIView!
    
    
    
    
    var productSample : ProductViewModel! {
        didSet {
            self.lblName.text = productSample.name
            self.txtSampleQty.text = productSample.sampleCount
            self.txtRxQty.text = productSample.rxCount
            self.txtRcpaQty.text = productSample.rcpaCount
            self.txtProductCount.text = productSample.availableCount
            self.btnDeviation.isSelected = productSample.isDetailed
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        txtProductCount.backgroundColor = .appLightTextColor.withAlphaComponent(0.3)
        [txtSampleQty,txtRxQty,txtRcpaQty, txtProductCount].forEach { textfield in
            if textfield != txtProductCount {
                textfield?.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
                textfield?.layer.borderWidth = 1.5
          
            }
            textfield?.layer.cornerRadius = 5
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textfield?.frame.height ?? 50))
            
            textfield?.leftView = paddingView
            textfield?.leftViewMode = .always
            
        }
        
    }
}
