//
//  SpecifiedTypeMenuVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/02/24.
//

import Foundation
import UIKit
import CoreData
class SpecifiedMenuVC : BaseViewController {
    @IBOutlet var specifiedMenuView: SpecifiedMenuView!
    var menuDelegate : MenuResponseProtocol?
    var celltype: MenuView.CellType = .listedDoctor
    var selectedObject: NSManagedObject?
    var previousselectedObj: NSManagedObject?
    var clusterMapID: String = ""
    var previewType: PreviewHomeView.PreviewType?
    var selectedClusterID: [String : Bool]?
    var selectedCompetitorsID: [String : Bool]?
    var isFromfilter = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- initWithStory
    class func initWithStory(_ delegate : MenuResponseProtocol?, celltype: MenuView.CellType)-> SpecifiedMenuVC{
        
        let view : SpecifiedMenuVC = UIStoryboard.Hassan.instantiateViewController()
        view.modalPresentationStyle = .overCurrentContext
        view.celltype = celltype
        view.menuDelegate = delegate


        
        return view
    }
    
}
