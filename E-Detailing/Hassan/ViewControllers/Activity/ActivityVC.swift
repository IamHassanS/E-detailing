//
//  ActivityVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 05/08/24.
//

import Foundation
import UIKit

class ActivityVC: BaseViewController {
    
    
    @IBOutlet var activityView: ActivityView!
  //  var reportsVM : ReportsVM?
  //  var appdefaultSetup : AppSetUp? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    class func initWithStory() -> ActivityVC {
        let tourPlanVC : ActivityVC = UIStoryboard.Hassan.instantiateViewController()
      //  tourPlanVC.reportsVM = ReportsVM()
        
        return tourPlanVC
    }
}
