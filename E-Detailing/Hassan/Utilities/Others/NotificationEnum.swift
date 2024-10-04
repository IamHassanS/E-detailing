
import UIKit


//MARK :- How to implement
// NotificationEnum.reported.addObserver(self, selector: #selector(self.remoteCallAnswerReceived(_:)))
// NotificationEnum.remoteInvitationReceived.removeObserver(self)

enum NotificationEnum :String {

    case reported
    case messageReceived
    case removeobserver
    case UIKeyboardWillHideNotification
    case viewMinimized
    case HQmodified
    
    func addObserver(_ observer:Any, selector: Selector){
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func removeObserver(_ observer:Any){
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotification(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
    
    func postNotificatinWithData(userInfo:JSON){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }
    
    func postNotificationWithJSONObj(_ userInfo:[String:AnyObject]) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: nil, userInfo: userInfo)
    }
    func postNotificationWithObject(_ object:AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.rawValue), object: object, userInfo: nil)
    }
    
    func removeAll(_ observer:Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
   
}
//
