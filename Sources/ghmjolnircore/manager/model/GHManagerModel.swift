//
//  GHManagerModel.swift
//  ghmjolnircore
//
//  Created by Javier Carapia on 25/01/22.
//

public class GHManagerModelBuilder {
    private var managerModel = GHManagerModel()
    
    public init () { }
    
    public func withType(type: Int) -> GHManagerModelBuilder {
        self.managerModel.type = type
        return self
    }
    
    public  func withController(controller: GHBaseViewControllerDelegate) -> GHManagerModelBuilder {
        self.managerModel.controller = controller
        return self
    }
    
    public func withBundle(bundle: GHBundleParameters?) -> GHManagerModelBuilder {
        self.managerModel.bundle = bundle
        return self
    }
    
    public func withViewModel(viewModel: GHBaseViewModelProtocol) -> GHManagerModelBuilder {
        self.managerModel.viewModel = viewModel
        return self
    }
    
    public func withCompletition(completion: (() -> Void)?) -> GHManagerModelBuilder {
        self.managerModel.completion = completion
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

public class GHManagerModel {
    public var type: Int?
    public var controller: GHBaseViewControllerDelegate?
    public var bundle: GHBundleParameters?
    public var viewModel: GHBaseViewModelProtocol?
    public var findClass: AnyClass?
    public var completion: (() -> Void)?
}
