//
//  GHLiveData.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

import Foundation

public class GHLiveData<T> {
    public typealias Listener = (T) -> ()
    private var listener: Listener?
    
    public var value: T {
        didSet {
            self.listener?(value)
        }
    }
    
    public init(_ v: T) {
        value = v
    }
    
    deinit {
        self.listener = nil
    }
    
    public func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    public func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
