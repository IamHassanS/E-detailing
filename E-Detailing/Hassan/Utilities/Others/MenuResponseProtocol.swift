import Foundation
import UIKit
import CoreData

enum AlertTypes: String {
    case clearSlides
}

protocol MenuAlertProtocols: AnyObject {
    func addAlert(_ type: AlertTypes)
}

 protocol MenuResponseProtocol: AnyObject {
    func routeToView(_ view : UIViewController)
    func callPlanAPI()
    func selectedType(_ type: MenuView.CellType, selectedObject: NSManagedObject, selectedObjects: [NSManagedObject])
     func passProductsAndInputs(additioncall: AdditionalCallsListViewModel, index: Int)

}
extension MenuResponseProtocol where Self : UIViewController{
    func callAdminForManualBooking() {
       // self.checkMobileNumeber()
    }
    func openThemeActionSheet(){
        //self.openThemeSheet()
    }
    func routeToView(_ view: UIViewController) {
        self.hidesBottomBarWhenPushed = true
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backAction"), object: self, userInfo: nil)
        self.navigationController?.pushViewController(view, animated: true)
        self.navigationController?.presentInFullScreen(view, animated: true, completion: nil)
    }
    func routeToHome(_ view: UIViewController) {
        self.hidesBottomBarWhenPushed = true
        self.modalPresentationStyle = .overFullScreen
        self.navigationController?.presentInFullScreen(view, animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "backAction"), object: self, userInfo: nil)
        self.navigationController?.pushViewController(view, animated: true)
        self.navigationController?.presentInFullScreen(view, animated: true, completion: nil)
    }
    func changeFont() {
        //self.openChangeFontSheet()
    }
    }

//
