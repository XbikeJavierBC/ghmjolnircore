//
//  GHManagerModel.swift
//  ghmjolnircore
//
//  Created by Javier Carapia on 25/01/22.
//

public protocol GHManagerModelDelegate {
    func getController() -> GHBaseViewControllerDelegate?
    func getViewModel() -> GHBaseViewModelProtocol?
}

public class GHManagerModel {
    public var type: Int?
    public var findClass: AnyClass?
    public var delegate: GHManagerModelDelegate?
}

public class GHManagerModelBuilder {
    private lazy var managerModel = GHManagerModel()
    
    public init () { }
    
    public func withType(type: Int) -> GHManagerModelBuilder {
        self.managerModel.type = type
        return self
    }
    
    public  func withDelegate(delegate: GHManagerModelDelegate) -> GHManagerModelBuilder {
        self.managerModel.delegate = delegate
        return self
    }
    
    public func withFindClass(findClass: AnyClass) -> GHManagerModelBuilder {
        self.managerModel.findClass = findClass
        return self
    }

    public func build() -> GHManagerModel {
        return self.managerModel
    }
}
