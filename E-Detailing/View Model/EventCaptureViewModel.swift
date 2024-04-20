//
//  EventCaptureViewModel.swift
//  E-Detailing
//
//  Created by SANEFORCE on 27/09/23.
//

import Foundation
import UIKit


class EventCaptureListViewModel {
    
    private var eventCaptureViewModel = [EventCaptureViewModel]()
    
    
    func addEventCapture(_ vm : EventCaptureViewModel) {
        eventCaptureViewModel.append(vm)
    }
    
    func numberOfRows() -> Int{
        return eventCaptureViewModel.count
    }
    
    func EventCaptureData () -> [EventCaptureViewModel] {
        return eventCaptureViewModel
    }
    
    func removeAtIndex(_ index : Int){
        eventCaptureViewModel.remove(at: index)
    }
    
    func fetchAtIndex(_ index : Int) -> EventCaptureViewModel {
        return eventCaptureViewModel[index]
    }
    
    func updateTitleAtIndex(_ index : Int, name : String) {
        eventCaptureViewModel[index].eventCapture.updateTitle(name)
    }
    
    func updateDescription(_ index : Int, remark : String){
        eventCaptureViewModel[index].eventCapture.updateDescription(remark)
    }
    
}

class EventCaptureViewModel {
    
    var eventCapture : EventCapture
    
    init(eventCapture: EventCapture) {
        self.eventCapture = eventCapture
    }
    
    var image : UIImage {
        return eventCapture.image
    }
    
    var title : String {
        return eventCapture.title
    }
    
    var description : String {
        return eventCapture.description
    }
    
}

struct EventCapture {
    
    var image : UIImage!
    var title : String = ""
    var description : String = ""
    var imageUrl : String!
    var time : String!
    var timeStamp : String!
    
    mutating func updateTitle(_ name : String) {
        title = name
    }
    
    mutating func updateDescription(_ remark : String) {
        description = remark
    }
    
}
