//
//  GHBundleParameters.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

public class GHBundleParameters {
    /// Para pasar los parametros entre views controllers.
    fileprivate lazy var _params: [String : Any?] = [:]
    
    /**
     Agrega un valor para pasar entre viewscontrollers.
     - parameters:
     - value: El valor que se desea agregar a la lista de parametros.
     - key: La llave en donde se guardara el valor.
     */
    public func add(_ value: Any?, key: String) {
        _params.updateValue(value, forKey: key)
    }
    
    /**
     Retorna el valor en tipo Int.
     - parameters:
     - key: El valor que se desea obtener del diccionario.
     - returns:
     El valor del diccionario de tipo Int.
     */
    public func getInt(_ key: String) -> Int {
        return _params[key] as? Int ?? -1
    }
    
    /**
     Retorna el valor en tipo String.
     - parameters:
     - key: El valor que se desea obtener del diccionario.
     - returns:
     El valor del diccionario de tipo String.
     */
    public func getString(_ key: String) -> String {
        return _params[key] as? String ?? ""
    }
    
    /**
     Retorna el valor en tipo Bool.
     - parameters:
     - key: El valor que se desea obtener del diccionario.
     - returns:
     El valor del diccionario de tipo Bool.
     */
    public func getBool(_ key: String) -> Bool {
        return _params[key] as? Bool ?? false
    }
    
    
    /**
     Retorna el objeto persistido.
     - parameters:
     - key: El valor que se desea obtener del diccionario.
     - returns:
     El objeto de tipo genreico.
     */
    public func get<T>(_ key: String) -> T? {
        guard let returna = _params[key] as? T else {
            return nil
        }
        
        return returna
    }
    
    /// Elimina de memoria todos los elementos del diccionario
    public func releaseSource() {
        _params.removeAll()
    }
}
