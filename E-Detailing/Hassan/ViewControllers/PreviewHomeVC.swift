//
//  PreviewHomeVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/02/24.
//

import Foundation
import UIKit
class PreviewHomeVC: BaseViewController {
    @IBOutlet var previewHomeView: PreviewHomeView!
    var delegate: PreviewHomeViewDelegate?
    var dcrCall : CallViewModel?
    var pageType: PreviewHomeView.pageType = .preview
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    class func initWithStory(previewType: PreviewHomeView.pageType? = .preview, dcrCall: CallViewModel? = nil) -> PreviewHomeVC {
        
        let reportsVC : PreviewHomeVC = UIStoryboard.Hassan.instantiateViewController()
        reportsVC.pageType = previewType ?? .preview
        reportsVC.dcrCall = dcrCall
        return reportsVC
    }
}
