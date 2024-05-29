//
//  SingleSelectionVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/12/23.
//

import UIKit

typealias SelectionCallBack = (_ selectedIndex : Int) -> Void



class SingleSelectionVC : UIViewController {
    
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    //var searchTitle : String!
    var selectionData = [AnyObject]()
    var originalData = [AnyObject]()
    var prevObj: [AnyObject]?
    var titleString: String?
    var selectionList = [SelectionList]()
    var originalList = [SelectionList]()
    var isForinputs: Bool = true
    var isFromStruct : Bool!
    weak var delegate: SingleSelectionVCDelegate?
    var completion : SelectionCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = titleString ?? ""
        self.originalData = self.selectionData
        
        self.originalList = self.selectionList
        

    }
    
    
    func didSelectCompletion(callback : @escaping SelectionCallBack) {
        self.completion = callback
    }
    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

protocol SingleSelectionVCDelegate: AnyObject {
    func didUpdate(selectedObj: AnyObject, index: Int)
}

extension SingleSelectionVC : tableViewProtocols {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if self.isFromStruct == true {
//            return self.selectionList.count
//        }
        
        return self.selectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionCell", for: indexPath) as! SingleSelectionCell
        
    
        cell.selectionStyle = .none
        if isForinputs {
            cell.samplesView.isHidden = true
        } else {
            cell.samplesView.isHidden = false
        }
        
        cell.lblName.text = self.selectionData[indexPath.row].name
        if let selectedProduct = self.selectionData[indexPath.row] as? Product {
            cell.product = selectedProduct
        }
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
//        if self.isFromStruct == true {
//            let lists = self.selectionList[indexPath.row]
//            
//            if let index = self.originalList.firstIndex(where: { (list) -> Bool in
//                
//                return list.code == lists.code
//            }){
//                if let completion = self.completion {
//                    completion(index)
//                }  
//            }
//            self.dismiss(animated: true)
//            return 
//        }
        
        
        let lists = self.originalData[indexPath.row]

        
        if let index = self.originalData.firstIndex(where: { (list) -> Bool in
            
            print(self.originalData)
            return list.code ?? "" == lists.code ?? ""
        }){
            var isExists: Bool = false
            if let prevObjs = self.prevObj as? [Product], let tempList = lists as? Product {
                prevObjs.enumerated().forEach { index, prevObj in
                    if prevObj.code == tempList.code {
                        self.toCreateToast("Product already selected.")
                        isExists = true
                    }
                }
            }
            
            if let prevObjs = self.prevObj as? [Input], let tempList = lists as? Input {
                prevObjs.enumerated().forEach { index, prevObj in
                    if prevObj.code == tempList.code {
                        self.toCreateToast("Input already selected.")
                        isExists = true
                    }
                }
            }
            
            if !isExists {
                self.delegate?.didUpdate(selectedObj: lists, index: index)
                self.dismiss(animated: true)
            }
           
        }
        
    }
}

class SingleSelectionCell : UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet var samplesVXview: UIVisualEffectView!
    
    @IBOutlet var samplesView: UIView!
    
    @IBOutlet weak var lblSample: UILabel!
    
    
    var product : Product! {
        
        didSet {
            lblName.text = product.name
            
            let productMode = product.productMode ?? ""
            
            if productMode == "Sale/Sample" {
                lblSample.text = "SM/SL"
                lblSample.textColor = .appLightTextColor
                samplesVXview.backgroundColor = .appLightTextColor
            }else if productMode == "Sample" {
                lblSample.text = " SM "
                lblSample.textColor = .appLightPink
                samplesVXview.backgroundColor = .appLightPink
                
            }else if productMode == "Sale" {
                lblSample.text = " SL "
                lblSample.textColor = .appBlue
                samplesVXview.backgroundColor = .appBlue
            }
            
//            if product.priority != "" {
//                lblSample.text = product.priority
//                lblSample.textColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(198.0/255.0), blue: CGFloat(137.0/255.0), alpha: CGFloat(1.0))
//                samplesVXview.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(198.0/255.0), blue: CGFloat(137.0/255.0), alpha: CGFloat(0.15))
//            }
//            
//            btnSelected.isSelected = product.isSelected
//            if product.isSelected {
//                lblName.textColor = .appTextColor
//            } else {
//                lblName.textColor = .appLightTextColor
//            }
         
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

 
//struct SelectionData {
//    var name : String!
//    var id : String!
//}
