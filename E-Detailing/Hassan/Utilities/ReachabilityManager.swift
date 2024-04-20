import UIKit
import Reachability

class ReachabilityManager : NSObject {
    static let sharedInstance: ReachabilityManager = {
        return ReachabilityManager() }()
    var reachability: Reachability!
    
    
    enum ReachabilityStatus: String {
        case wifi         = "WiFi"
        case cellular     = "Cellular"
        case notConnected = "No Connection"
    }
    
    override init() {
        super.init()
        reachability = try! Reachability()
        NotificationCenter.default.addObserver( self,  selector: #selector(networkStatusChanged(_:)), name: .reachabilityChanged, object: reachability)
        //  print(reachability.connection)
        // Start the network status notifier
        do {
            try reachability.startNotifier()
            
        } catch {
            
            print("Unable to start notifier")
            
        }
        
    }
    @objc func networkStatusChanged(_ notification: Notification) {
        //        NotificationCenter.default.post(name: NSNotification.Name("connectionChanged"), object: reachability, userInfo: nil)
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            //  LocalStorage.shared.setSting(LocalStorage.LocalValue.connectivity, text: reachability.connection.description)
        case .cellular:
            print("Reachable via Cellular")
            //  LocalStorage.shared.setSting(LocalStorage.LocalValue.connectivity, text: reachability.connection.description)
        case .unavailable:
            print("Network not reachable")
            //  LocalStorage.shared.setSting(LocalStorage.LocalValue.connectivity, text: reachability.connection.description)
        case .none:
            break
        }
        let connectionDict:[String: String] = ["Type": reachability.connection.description]
        NotificationCenter.default.post(name: NSNotification.Name("connectionChanged"), object: reachability, userInfo: connectionDict)
        // Do something globally here!    }
    }
    static func stopNotifier() -> Void {
        // Stop the network status notifier
        // do {
        //    try
        (ReachabilityManager.sharedInstance.reachability).stopNotifier()
        
        //  } catch {
        //      print("Error stopping notifier")
        
        //   }
        
    }
    
    static func isReachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection != .unavailable {            completed(ReachabilityManager.sharedInstance)
            
        }
        
    }
    
    static func isUnreachable(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .unavailable {            completed(ReachabilityManager.sharedInstance)
            
        }
        
    }
    
    
    
    static func isReachableViaWWAN(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .cellular {            completed(ReachabilityManager.sharedInstance)
            
        }
        
    }
    
    static func isReachableViaWiFi(completed: @escaping (ReachabilityManager) -> Void) {
        if (ReachabilityManager.sharedInstance.reachability).connection == .wifi {
            completed(ReachabilityManager.sharedInstance)
            
        }
        
    }
    
    
}

//
