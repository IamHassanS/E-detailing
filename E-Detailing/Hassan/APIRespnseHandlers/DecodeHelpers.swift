//
//  DecodeHelpers.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/11/23.
//

import Foundation
typealias JSON = [String: Any]
extension Dictionary where Dictionary == JSON {
    var status_code : Bool {
        return (self["success"]) as! Bool
    }
    
    
    
    var isSuccess : Bool{
        return status_code
        //!= 0
    }
    init?(_ data : Data){
          if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
              self = json
          }else{
              return nil
          }
      }
    var status_message : String {
        
        let statusMessage = self.string("status_message")
        let successMessage = self.string("msg")
        return statusMessage.isEmpty ? successMessage : statusMessage
    }

    
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSON]{
        return self[key] as? [JSON] ?? [JSON]()
    }
    func json(_ key : String) -> JSON{
        return self[key] as? JSON ?? JSON()
    }
     func string(_ key : String)-> String{
         let value = self[key]
         if let str = value as? String{
            return str
         }else if let int = value as? Int{
            return int.description
         }else if let double = value as? Double{
            return double.description
         }else{
            return String()
         }
     }
    func nsString(_ key: String)-> NSString {
        return self.string(key) as NSString
    }
     func int(_ key : String)-> Int{
         //return self[key] as? Int ?? Int()
         let value = self[key]
         if let str = value as? String{
            return Int(str) ?? Int()
         }else if let int = value as? Int{
            return int
         }else if let double = value as? Double{
            return Int(double)
         }else{
            return Int()
         }
     }
     func double(_ key : String)-> Double{
     //return self[key] as? Double ?? Double()
         let value = self[key]
         if let str = value as? String{
            return Double(str) ?? Double()
         }else if let int = value as? Int{
            return Double(int)
         }else if let double = value as? Double{
            return double
         }else{
            return Double()
         }
     }
    
    func bool(_ key : String) -> Bool{
        let value = self[key]
        if let bool = value as? Bool{
            return bool
        }else if let int = value as? Int{
            return int == 1
        }else if let str = value as? String{
            return ["1","true"].contains(str)
        }else{
            return Bool()
        }
    }
    
    func value<T>(forKeyPath path : String) -> T?{
        var keys = path.split(separator: ".")
        var childJSON = self
        let lastKey : String
        if let last = keys.last{
            lastKey = String(last)
        }else{
            lastKey = path
        }
        keys.removeLast()
        for key in keys{
            childJSON = childJSON.json(String(key))
        }
        return childJSON[lastKey] as? T
    }

    
    func setModelArray<T:BaseClass>(_ key:String, type:T.Type)-> [T] {
        var baseModel = [T]()
        self.array(key).forEach { (json) in
            let model = T(json)
            baseModel.append(model)
        }
        return baseModel
        
    }
    
    func setModel<T:BaseClass>(_ key:String, type:T.Type)-> T {
        let baseModel = T(self.json(key))
        return baseModel
        
    }
    
    func setModel<T:BaseClass>( type:T.Type)-> T {
        let baseModel = T(self)
        return baseModel
    }
    
}


public
func debug(print msg: String,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: CustomStringConvertible,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.description) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: CustomDebugStringConvertible,
           file : String = #file,
           fun : String = #function,
           line : Int = #line) {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.debugDescription) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}
public
func debug(print msg: Error,
           file : String = #file,
           fun : String = #function,
           line : Int = #line){
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("∂:/ message: \(msg.localizedDescription) -> file: \(fileName) -> function : \(fun) -> line : \(line.description)")
}




class BaseClass {
   
    required init(_ json:JSON) {
        
    }
    
    init(){
        
    }
}
