//
//  BaseViewModel.swift
//  SAN ZEN
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/01/24.
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
