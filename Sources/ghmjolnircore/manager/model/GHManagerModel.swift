//
//  GHManagerModel.swift
//  ghmjolnircore
//
//  Created by Javier Carapia on 25/01/22.
//

import Foundation

public protocol GHManagerModelDelegate {
    func getController() -> GHBaseViewControllerDelegate?
    func getViewModel() -> GHBaseViewModelProtocol?
}

public class GHManagerModel {
    public var type: Int?
    public var bundle: Bundle?
    public var delegate: GHManagerModelDelegate?
}

public class GHManagerModelBuilder {
    private lazy var managerModel = GHManagerModel()
    
    public init () { }
    
    public func withType(type: Int) -> GHManagerModelBuilder {
        self.managerModel.type = type
        return self
    }
    
    public func withDelegate(delegate: GHManagerModelDelegate) -> GHManagerModelBuilder {
        self.managerModel.delegate = delegate
        return self
    }
    
    public func withBundle(bundle: Bundle) -> GHManagerModelBuilder {
        self.managerModel.bundle = bundle
        return self
    }

    public func build() -> GHManagerModel {
        return self.managerModel
    }
}
