//
//  File.swift
//  
//
//  Created by Javier Carapia on 12/04/22.
//

public class GHScrollDictionary {
    fileprivate lazy var _params: [Int : Any?] = [:]
    
    public static var sharedInstance: GHScrollDictionary {
        struct Singleton {
            static let instance = GHScrollDictionary()
        }
        return Singleton.instance
    }
    
    private init() { }
    
    func add(_ value: Any?, key: Int) {
        _params.updateValue(value, forKey: key)
    }
    
    public func get<T>(_ key: Int) -> T? {
        if let returna = _params[key] as? T {
            return returna
        }
        return nil
    }
    
    func releaseSource() {
        _params.removeAll()
    }
}
