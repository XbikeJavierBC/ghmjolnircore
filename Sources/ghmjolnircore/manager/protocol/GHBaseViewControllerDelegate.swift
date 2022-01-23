//
//  GHBaseViewControllerDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

import UIKit

public protocol GHBaseViewControllerDelegate: AnyObject {
    var bundle: GHBundleParameters? { get set }
    var controllerType: Int? { get set }
    var controllerManager: GHManagerController? { get set }
    var viewModel: GHBaseViewModelProtocol? { get set }
    
    static func instantiate(fromStoryboard nibName: String) -> Self
    
    func removeReferenceContext()
}

extension GHBaseViewControllerDelegate where Self: UIViewController {
    public static func instantiate(fromStoryboard nibName: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: nibName, bundle: .main)
        let controller = storyboard.instantiateViewController(withIdentifier: id)
        return controller as! Self
    }
    
    public func removeReferenceContext() {
        self.bundle             = nil
        self.viewModel          = nil
        self.controllerType     = nil
        self.controllerManager  = nil
    }
}
