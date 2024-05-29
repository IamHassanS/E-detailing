//
//  CreatePresentationVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 24/01/24.
//

import Foundation
import UIKit


protocol CreatePresentationVCDelegate: AnyObject {
    func presentationSaved()
}


class CreatePresentationVC: BaseViewController {
    
    @IBOutlet var createPresentationView: CreatePresentationView!
    
    
    weak var delegate: CreatePresentationVCDelegate?
    var isToedit: Bool = false
  
    var savedPresentation : SavedPresentation?
    
    
    
    deinit {
        
        createPresentationView.arrayOfBrandSlideObjects = nil
        createPresentationView.arrayOfAllSlideObjects = nil
        createPresentationView.groupedBrandsSlideModel = nil
        createPresentationView.savedPresentation = nil
        createPresentationView.selectedSlides = nil
        savedPresentation = nil
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func initWithStory() -> CreatePresentationVC {
        let reportsVC : CreatePresentationVC = UIStoryboard.Hassan.instantiateViewController()

        return reportsVC
    }
}
