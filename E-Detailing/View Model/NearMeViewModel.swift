//
//  NearMeViewModel.swift
//  E-Detailing
//
//  Created by SANEFORCE on 31/08/23.
//

import Foundation


class VisitListViewModel {
    
    private var visitListViewModel = [VisitViewModel]()
    private var tagTitleListViewModel = [TagTitleViewModel]()
    
    func fetchDataAtIndex(_ index : Int) -> VisitViewModel {
        return visitListViewModel[index]
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
}


struct tagTitle {
    
    var name : String
    var type : TaggingType
}
