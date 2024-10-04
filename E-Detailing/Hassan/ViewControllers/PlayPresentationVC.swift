//
//  PlayPresentationVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import Foundation
import UIKit
class PlayPresentationVC: BaseViewController {
    weak var delegete: PlayPresentationViewDelegate?
    var previewTypeIndex: Int = 0
    var selectedSlideModel: [SlidesModel]?
    @IBOutlet var playPresentationView: PlayPresentationView!
    var pagetype: PreviewHomeView.pageType = .preview
    var pageState: PlayPresentationView.PageState = .expanded
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigationController = self.navigationController {
               navigationController.interactivePopGestureRecognizer?.isEnabled = false
           }
        // Do any additional setup after loading the view.
    }
    class func initWithStory(model: [SlidesModel], pagetype: PreviewHomeView.pageType? = .preview, pagestate: PlayPresentationView.PageState) -> PlayPresentationVC {
        let reportsVC : PlayPresentationVC = UIStoryboard.Hassan.instantiateViewController()
        reportsVC.pagetype = pagetype ?? .preview
        reportsVC.selectedSlideModel = model
        return reportsVC
    }
}
