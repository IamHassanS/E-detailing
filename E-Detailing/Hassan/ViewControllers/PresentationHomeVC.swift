//
//  PresentationHomeVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 23/01/24.
//

import Foundation
import UIKit
class PresentationHomeVC: BaseViewController {
    @IBOutlet var presentationHomeView: PresentationHomeView!
    var mastersyncVM: MasterSyncVM?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    class func initWithStory() -> PresentationHomeVC {
        let reportsVC : PresentationHomeVC = UIStoryboard.Hassan.instantiateViewController()
        return reportsVC
    }
}
