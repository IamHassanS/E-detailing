//
//  BaseViewModel.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/11/23.
//

import Foundation

class BaseViewModel : NSObject{
    lazy var connectionHandler : ConnectionHandler? = {
        return ConnectionHandler()
    }()
    
    override init() {
        super.init()
    }
    

    
}
