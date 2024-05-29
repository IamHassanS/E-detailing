//
//  APIResponseHandler.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/01/24.
//

import Foundation

class APIResponseHandler : APIResponseProtocol{
  
    init(){
    }
    var jsonArrSeq : Closure<[JSON]>?
    var jsonSeq : Closure<JSON>?
    var dataSeq : Closure<Data>?
    var errorSeq : Closure<String>?
    
    func responseDecode<T>(to modal: T.Type, _ result: @escaping Closure<T>) -> APIResponseProtocol where T : Decodable {
        
        let decoder = JSONDecoder()
        self.dataSeq =  decoder.decode(modal, result: result)
        
        return self
    }
    
    func responseJSON(_ result: @escaping Closure<JSON>) -> APIResponseProtocol {
        self.jsonSeq = result
        return self
    }
    
    
    func responseArrJSON(_ result: @escaping Closure<[JSON]>) -> APIResponseProtocol {
        self.jsonArrSeq = result
        return self
    }
    
    
    func responseFailure(_ error: @escaping Closure<String>) {
        self.errorSeq = error
        
      }

    func handleSuccess(value : JSON, data : Data){
        //
        if let jsonEscaping = self.jsonSeq{
            jsonEscaping(value as JSON)
        }
        if let dataEscaping = dataSeq{
            dataEscaping(data)
            
        }
    }
    
    
    func handleArrSuccess(value : [JSON], data : Data){
        if let jsonEscaping = self.jsonArrSeq{
            jsonEscaping(value as [JSON])
        }
        if let dataEscaping = dataSeq{
            dataEscaping(data)
        }
    }
    
    func handleFailure(value : String){
        self.errorSeq?(value)
     }
   
}
