//
//  DCRdetailViewEditVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 06/03/24.
//

import Foundation
import UIKit
import CoreData
class DCRdetailViewEditVC: BaseViewController {

    enum EditTypes {
        case doctor
        case chemist
        case stockist
        case unlistedDoctor
        case cip
        case hospital
    }
    
    @IBOutlet var dcrDetailViewEditView: DCRdetailViewEditView!
    var pageType: EditTypes = .doctor
    var coreModal: NSManagedObject?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    

    class func initWithStory(type: EditTypes, model: NSManagedObject) -> DCRdetailViewEditVC {
        let detailViewEditVC : DCRdetailViewEditVC = UIStoryboard.Hassan.instantiateViewController()
        detailViewEditVC.pageType = type
        detailViewEditVC.coreModal = model
        return detailViewEditVC
    }
    
    func setupModel()  {

        switch pageType {
            
        case .doctor:
            dcrDetailViewEditView.listedDoctor = coreModal as? DoctorFencing
        case .chemist:
            dcrDetailViewEditView.chemist = coreModal as? Chemist
        case .stockist:
            dcrDetailViewEditView.stockist = coreModal as? Stockist
        case .unlistedDoctor:
            dcrDetailViewEditView.unlistedDoctor = coreModal as? UnListedDoctor
        case .cip:
            print("Yet to implement")
        case .hospital:
            print("Yet to implement")
        }
        
        dcrDetailViewEditView.toPopulateVIew()
        
    }
    
}
