//
//  ProductInputSelectionVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 27/12/23.
//

import UIKit

class ProductInputSelectionVC : UIViewController {
    
    enum controllerType {
        case Product
        case Input
    }
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var btnCancel: UIButton!
    //var searchTitle : String!
    var pageType: controllerType = .Input
    var productSelectedListViewModel = ProductSelectedListViewModel()
    var inputSelectedListViewModel = InputSelectedListViewModel()
    var prevObj: [AnyObject]?
    var selectedProductID = [String: Bool]()
    var selectedInputID = [String: Bool]()
    var titleString: String?
    weak var delegate: ProductInputSelectionVCDelegate?
    var inputArr: [Input] = []
    var productArr: [Product] = []
    var searchText: String = ""
    var dcrCall : CallViewModel!
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : ProductInputSelectionVCDelegate?, productViewModel: ProductSelectedListViewModel, inputViewModel: InputSelectedListViewModel,  dcrCall:  CallViewModel, type:  ProductInputSelectionVC.controllerType, selectedProducts: [Product?], selectedInputs: [Input?])-> ProductInputSelectionVC{
        let view : ProductInputSelectionVC = UIStoryboard.activity.instantiateViewController()
        view.productSelectedListViewModel = productViewModel
        view.inputSelectedListViewModel = inputViewModel
    
        selectedProducts.compactMap { $0 }.forEach { product in
            let code = product.code ?? ""
            view.selectedProductID[code] = true
        }
        
        selectedInputs.compactMap { $0 }.forEach { input in
            let code = input.code ?? ""
            view.selectedInputID[code] = true
        }
        view.delegate = delegate
        view.dcrCall = dcrCall
        view.pageType = type
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegistration()
        btnCancel.layer.cornerRadius = 5
        btnSave.layer.cornerRadius = 5
        self.lblName.text = pageType  == .Input ? "Select Inputs" : "Select Products"

    }
    
    func cellRegistration() {
        self.tableView.register(UINib(nibName: "ProductNameWithSampleTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameWithSampleTableViewCell")
        
        self.tableView.register(UINib(nibName: "ProductNameTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNameTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @IBAction func userDidSave(_ sender: Any) {
    
        
        self.dismiss(animated: true) {
            switch self.pageType {
                
            case .Product:
                let cacheProducts = DBManager.shared.getProduct()
                let filteredProducts  = cacheProducts.filter { aProduct in
                       guard let code = aProduct.code else {
                           return false
                       }
                    return self.selectedProductID[code] == true
                   }

                
                self.delegate?.didUpdate(selectedObj: filteredProducts, type: .Product)
            case .Input:
                
                let cacheInputs = DBManager.shared.getInput()
                let filteredInputs  = cacheInputs.filter { aInput in
                       guard let code = aInput.code else {
                           return false
                       }
                    return self.selectedInputID[code] == true
                   }

                
                self.delegate?.didUpdate(selectedObj: filteredInputs, type: .Input)
   
            }
            
          
        }
        
    }
    
    @IBAction func userDidCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

    
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}

protocol ProductInputSelectionVCDelegate: AnyObject {
    func didUpdate(selectedObj: [AnyObject], type: ProductInputSelectionVC.controllerType)
}

extension ProductInputSelectionVC : tableViewProtocols {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch pageType {
            
        case .Product:
            switch section {
            case 0:
                return 1
            default:
                return self.productSelectedListViewModel.numberOfProducts(searchText: self.searchText)
            }
        case .Input:
            switch section {
            case 0:
                return 1
            default:
                return self.inputSelectedListViewModel.numberOfInputs(searchText: self.searchText)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch pageType {
            
        case .Product:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameWithSampleTableViewCell", for: indexPath) as! ProductNameWithSampleTableViewCell
                cell.lblName.text = "No products"
                cell.samplesView.isHidden = true
                
                cell.btnSelected.isSelected = false
 
                    if selectedProductID.isEmpty {
                        cell.btnSelected.isSelected = true
                    } else {
                        cell.btnSelected.isSelected = false
                    }
                
                cell.lblName.textColor =    cell.btnSelected.isSelected ? .appTextColor : .appLightTextColor
                
                cell.addTap {
                    self.selectedProductID.removeAll()
                    self.tableView.reloadData()
                   
                    
                }
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameWithSampleTableViewCell", for: indexPath) as! ProductNameWithSampleTableViewCell

                cell.samplesView.isHidden = false
                let model = self.productSelectedListViewModel.fetchProductData(indexPath.row, searchText: self.searchText, type: self.dcrCall.type,selectedDoctorCode: self.dcrCall.code)
                cell.product = model
                cell.selectionStyle = .none
                cell.btnSelected.isUserInteractionEnabled = false
                cell.btnSelected.isSelected = false
  
                        //  dump(cluster.code)
                if  !self.selectedProductID.isEmpty {
                    self.selectedProductID.forEach { id, isSelected in
                        if id == model.Object.code {

                                if isSelected  {
                                
                                        cell.btnSelected.isSelected = true
                                    
                                    
                                } else {
                                    cell.btnSelected.isSelected = false
                                }
                            } 
                        }
                }

                    
  
                cell.lblName.textColor =    cell.btnSelected.isSelected ? .appTextColor : .appLightTextColor
                
                
                cell.addTap { [weak self] in
                    guard let welf = self else {return}
                     var selectedProductID = welf.selectedProductID
                    
                    if let product =  model.Object as? Product {
                        if let _ = selectedProductID[product.code ?? ""] { 
                            
                            
                            selectedProductID[product.code ?? ""] =
                                !(selectedProductID[product.code ?? ""] ?? false)

                            if selectedProductID[product.code ?? ""] == false {
                                selectedProductID.removeValue(forKey: product.code ?? "")
                            }
                            
                        } else {
                            selectedProductID[product.code ?? ""] = true
                        }


                    }
                    
                    welf.selectedProductID = selectedProductID
                    tableView.reloadData()
                }
                return cell
            }
        case .Input:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell", for: indexPath) as! ProductNameTableViewCell
                cell.lblName.text = "No Inputs"
                cell.btnSelected.isSelected = false
                if selectedInputID.isEmpty {
                    cell.btnSelected.isSelected = true
                } else {
                    cell.btnSelected.isSelected = false
                }
                cell.lblName.textColor =    cell.btnSelected.isSelected ? .appTextColor : .appLightTextColor
                
                cell.addTap {
                    self.inputSelectedListViewModel.removeAllInputs()
                    self.tableView.reloadData()
               
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNameTableViewCell", for: indexPath) as! ProductNameTableViewCell
                cell.selectionStyle = .none
                let model = self.inputSelectedListViewModel.fetchInputData(indexPath.row, searchText: self.searchText)
                cell.input = model
                cell.btnSelected.isUserInteractionEnabled = false
                cell.btnSelected.isSelected = false
  
                        //  dump(cluster.code)
                if  !self.selectedInputID.isEmpty {
                    self.selectedInputID.forEach { id, isSelected in
                        if id == model.Object.code {

                                if isSelected  {
                                
                                        cell.btnSelected.isSelected = true
                                    
                                    
                                } else {
                                    cell.btnSelected.isSelected = false
                                }
                            }
                        }
                }

                    
  
                cell.lblName.textColor =    cell.btnSelected.isSelected ? .appTextColor : .appLightTextColor
                
                
                cell.addTap { [weak self] in
                    guard let welf = self else {return}
                     var selectedProductID = welf.selectedInputID
                    
                    if let product =  model.Object as? Input {
                        if let _ = selectedProductID[product.code ?? ""] {
                            
                            
                            selectedProductID[product.code ?? ""] =
                                !(selectedProductID[product.code ?? ""] ?? false)

                            if selectedProductID[product.code ?? ""] == false {
                                selectedProductID.removeValue(forKey: product.code ?? "")
                            }
                            
                        } else {
                            selectedProductID[product.code ?? ""] = true
                        }


                    }
                    
                    welf.selectedInputID = selectedProductID
                    tableView.reloadData()
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
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
