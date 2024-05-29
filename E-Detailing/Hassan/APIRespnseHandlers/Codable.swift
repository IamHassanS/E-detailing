//
//  Codable.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 07/01/24.
//


import Foundation

//MARK:- KeyedDecodingContainer
public extension KeyedDecodingContainer{
    
    func safeDecodeValue<T : SafeDecodable & Decodable>(forKey key : Self.Key) -> T{
        
        if let value = try? self.decodeIfPresent(T.self, forKey: key){
            return value
        }else if let value = try? self.decodeIfPresent(String.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Int.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Float.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Double.self, forKey: key){
            return value.cast()
        }else if let value = try? self.decodeIfPresent(Bool.self, forKey: key){
            return value.cast()
        }
       // debug(print: "Key Missing : \(key.stringValue)")
        return T.init()
       
    }
   
}

//MARK:- protocol SafeDecodable
public protocol Initializable {
    init()
}

public protocol DefaultValue : Initializable {}
extension DefaultValue {
    static var `default` : Self{return Self.init()}
}

public protocol SafeDecodable : DefaultValue{}
extension SafeDecodable{
    func cast<T: SafeDecodable>() -> T{return T.init()}
}

//extension RawRepresentable where RawValue == String {
//    var description: String {
//        return rawValue
//    }
//
//
//}

//MARK:- Int
extension Int : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.default
    }
    
    
}
//MARK:- Double
extension Double : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Float
extension Float : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Int.Type:
            castValue = Int(self) as? T
        case let x where x is Bool.Type:
            castValue = (self != 0) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- String
extension String : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is Int.Type:
            castValue = Int(self.description) as? T
        case let x where x is Double.Type:
            castValue = Double(self) as? T
        case let x where x is Bool.Type:
            castValue = ["true","yes","1"]
                .contains(self.lowercased()) as? T
        case let x where x is Float.Type:
            castValue = Float(self) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Bool
extension Bool : SafeDecodable{
    public func cast<T>() -> T where T : SafeDecodable {
        let castValue : T?
        switch T.self {
        case let x where x is String.Type:
            castValue = self.description as? T
        case let x where x is Double.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Bool.Type:
            castValue = (self ? 1 : 0) as? T
        case let x where x is Float.Type:
            castValue = (self ? 1 : 0) as? T
        default:
            castValue = self as? T
        }
        return castValue ?? T.init()
    }
}
//MARK:- Array
extension Array : SafeDecodable{
    public static var `default` : Array<Element> {return Array<Element>()}
    public func cast<T>() -> T where T : SafeDecodable {
       return T.init()
    }
}
//
