//
//  FAQwebController.swift
//  SAN ZEN
//
//  Created by San eforce on 28/09/24.
//

import Foundation
import UIKit
import WebKit
class FAQwebController: UIViewController{
    
    @IBOutlet var backHolderView: UIView!
    
    @IBOutlet var lblFAQ: UILabel!
    
    
    @IBOutlet var webview: WKWebView!
    
    
    
    override func viewDidLoad() {
        initView()
       // guard let saneforceURL = URL(string: "https://san.saneforce.com/zenfaq/index.html") else {return}
        
      //  let request = URLRequest(url: saneforceURL)
        
        saveData()
     
        
        
    }
    
    
    func saveData() {
        guard let saneforceURL = URL(string: "https://san.saneforce.com/zenfaq/index.html") else {return}
        
        let request = URLRequest(url: saneforceURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                // Try to load cached response if there's no internet
                if let cachedResponse = URLCache.shared.cachedResponse(for: request), let url = cachedResponse.response.url {
                    print("Loaded from cache")
                    // Use cached data
                    let cachedData = cachedResponse.data
                    // Process cached data
                    DispatchQueue.main.async {[weak self] in
                        self?.webview.load(cachedData, mimeType: cachedResponse.response.mimeType ?? "text/html", characterEncodingName: "UTF-8", baseURL: url)
                    }
                }
                
                return
            }
            
            // If response is successful, cache it
            if let httpResponse = response as? HTTPURLResponse, let data = data, error == nil {
                // Cache the response
                URLCache.shared.removeCachedResponse(for: request)
                let cachedResponse = CachedURLResponse(response: httpResponse, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                let cachedData = cachedResponse.data
                // Process cached data
                if let requestURL = cachedResponse.response.url {
                    DispatchQueue.main.async {
                        self.webview.load(cachedData, mimeType: cachedResponse.response.mimeType ?? "text/html", characterEncodingName: "UTF-8", baseURL: requestURL)
                    }
               
                }
              
            }
        }

        task.resume()
    }
    

    
    
    func initView() {
        backHolderView.addTap {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    class func initWithStory()-> FAQwebController{
        
        let view : FAQwebController = UIStoryboard.Hassan.instantiateViewController()
        return view
    }
}
