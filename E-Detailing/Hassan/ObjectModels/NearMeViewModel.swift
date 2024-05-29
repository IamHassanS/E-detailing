//
//  NearMeViewModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 31/04/24.
//

import Foundation
import CoreLocation

class VisitListViewModel {
    
    private var visitListViewModel = [VisitViewModel]()
    private var tagTitleListViewModel = [TagTitleViewModel]()
    
    func fetchDataAtIndex(_ index : Int) -> VisitViewModel {
        return visitListViewModel[index]
    }
    
    
    func fetchDataWithCode(_ code : String) -> VisitViewModel? {
       return visitListViewModel.filter { $0.custCode == code }.first
    }
    
    func numbersOfRows() -> Int {
        return visitListViewModel.count
    }
    
    func addVisitViewModel (_ VM : VisitViewModel) {
        visitListViewModel.append(VM)
    }
    
    func removeAll() {
        visitListViewModel.removeAll()
    }
    
    func addTitleViewModel(_ VM : TagTitleViewModel) {
        tagTitleListViewModel.append(VM)
    }
    
    func fetchTitleAtIndex(_ index : Int) -> TagTitleViewModel {
        tagTitleListViewModel[index]
    }
    
    func numberofTitles() -> Int {
        return tagTitleListViewModel.count
    }
    
}


class VisitViewModel {
    
    let taggedDetail : TaggedDetails
    
    
    init(taggedDetail: TaggedDetails) {
        self.taggedDetail = taggedDetail
    }
    
    var name : String {
        return taggedDetail.name
    }
    
    var address : String {
        return taggedDetail.address
    }
    
    var meter : String {
        return taggedDetail.meter
    }
    
    var coordinates : CLLocationCoordinate2D {
        return taggedDetail.coordinates
    }
    
    var custCode : String {
        return taggedDetail.custCode
    }
    
    var imageURL  : String {
        return taggedDetail.imageURL
    }
    
}

class TagTitleViewModel {
    
    let tagTitle : tagTitle
    
    init(tagTitle: tagTitle) {
        self.tagTitle = tagTitle
    }
    
    
    var name : String {
        return tagTitle.name
    }
    
    var type : TaggingType {
        return tagTitle.type
    }
    
}



struct TaggedDetails {
    
    var name : String
    var address : String
    var meter : String
    var coordinates: CLLocationCoordinate2D
    var custCode: String
    var imageURL: String
    var tagType: TaggingType
}


struct tagTitle {
    
    var name : String
    var type : TaggingType
}
