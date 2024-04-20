//
//  ReportsVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 20/12/23.
//

import UIKit

class ReportsVC: BaseViewController {

    
    enum PageType {
        case reports
        case approvals
        case myResource
    }
    
    @IBOutlet var reportsView: ReportsView!
    var pageType: PageType = .reports
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory(pageType: PageType) -> ReportsVC {
        let reportsVC : ReportsVC = UIStoryboard.Hassan.instantiateViewController()
      //  tourPlanVC.homeVM = HomeViewModal()
        reportsVC.pageType = pageType
        return reportsVC
    }

}
