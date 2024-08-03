//
//  TourPlanVC.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 09/01/24.
//

import Foundation
import UIKit
class TourPlanVC: BaseViewController {
    
  //  var homeVM: HomeViewModal?
    var tourplanVM: TourPlanVM?
   
    @IBOutlet var tourPlanView: TourPlanView!
    
    
    override func viewDidLoad() {
        
       
    }
    
    
    class func initWithStory() -> TourPlanVC {
        let tourPlanVC : TourPlanVC = UIStoryboard.Hassan.instantiateViewController()
        tourPlanVC.tourplanVM = TourPlanVM()
        return tourPlanVC
    }
    
    
    func getAllPlansData(_ param: [String: Any], paramData: JSON, completion: @escaping (Result<SessionResponseModel,Error>) -> Void){
      
        tourplanVM?.getTourPlanData(params: param, api: .getAllPlansData, paramData: paramData) { result in
            switch result {
            case .success(let response):
                print(response)
                completion(.success(response))
                dump(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                
                completion(.failure(error))
            }
        }
    }
}
    



