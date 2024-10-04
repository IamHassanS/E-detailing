//
//  PlayHTMLCVC.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 31/01/24.
//

import UIKit
import WebKit

    
class PlayHTMLCVC: UICollectionViewCell, WKUIDelegate, WKNavigationDelegate {
        static let  identifier = "PlayHTMLCVC"
        let webView: WKWebView = {
            let webVIew = WKWebView()
            //webVIew = WKWebView(frame: contentView.bounds)
            webVIew.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           // contentView.addSubview(webVIew)
            return webVIew
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupWebView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupWebView()
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            webView.frame = self.bounds
            contentView.addSubview(webView)
        }

        private func setupWebView() {
    
        }

    
    
    func loadURL(_ filepathURL: String) {
        if let url = URL(string: filepathURL) {
            // Create a base URL for the folder containing the HTML file
            let baseURL = url.deletingLastPathComponent()

            // Assuming webView is an instance of WKWebView
            webView.loadFileURL(url, allowingReadAccessTo: baseURL)
        } else {
            print("Error: Invalid file path.")
        }
    }
    }



