//
//  GHHelperControllerManager.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

import UIKit

public class GHManagerController {
    private var navigationController: UINavigationController?
    private lazy var viewControllers: [(type: Int, ctrDel: GHBaseViewControllerDelegate?)] = []
    
    public init(navBar: UINavigationController) {
        self.navigationController = navBar
    }
    
    public func setNavBarHiden(hidden: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    
    public func hideViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let item = self.getLastVcPresented() {
            if let controller = item.ctrDel as? UIViewController {
                if controller.navigationController == nil {
                    controller.dismiss(
                        animated: animated,
                        completion: completion
                    )
                }
                else {
                    self.navigationController?.popViewController(
                        animated: animated,
                        completion: completion
                    )
                }
            }
            
            self.releaseVcFromName(type: item.type)
        }
    }
    
    public func presentDangerNavigationViewController(type: Int) {
        if let index = self.viewControllers.firstIndex(where: { $0.type == type }) {
            for (indexCtrl, element) in self.viewControllers.enumerated() {
                if indexCtrl > index {
                    self.releaseVcFromName(type: element.type)
                }
            }
        }
        
        if let contrll = self.viewControllers.last, let uiController = contrll.ctrDel as? UIViewController {
            self.navigationController?.popToViewController(
                viewController: uiController,
                animated: true
            )
        }
    }
    
    public func presentRootNavigationViewController(
        managerModel: GHManagerModel,
        parameters: GHBundleParameters?,
        completion: (() -> Void)?
    ) {
        self.viewControllers.forEach { self.releaseVcFromName(type: $0.type) }
        
        self.presentNavigationViewController(
            managerModel: managerModel,
            parameters: parameters,
            completion: completion
        )
    }
    
    public func presentNavigationViewController(
        managerModel: GHManagerModel,
        parameters: GHBundleParameters?,
        completion: (() -> Void)?
    ) {
        if self.viewControllers.firstIndex(where: { $0.type == managerModel.type }) == nil {
            self.addControllerToList(
                managerModel: managerModel,
                parameters: parameters
            )
        }
        
        if let contrll = self.getLastVcPresented()?.ctrDel as? UIViewController {
            self.navigationController?.pushViewController(
                viewController: contrll,
                animated: true,
                completion: completion
            )
        }
    }
    
    public func presentPopUpViewController(
        managerModel: GHManagerModel,
        parameters: GHBundleParameters?,
        completion: (() -> Void)?
    ) {
        if self.viewControllers.firstIndex(where: { $0.type == managerModel.type }) == nil {
            self.addControllerToList(
                managerModel: managerModel,
                parameters: parameters
            )
        }
        
        if let contrll = self.getLastVcPresented()?.ctrDel as? UIViewController,
           let penContrll = self.getPenultimateVcPresented()?.ctrDel as? UIViewController {
            contrll.modalPresentationStyle  = .fullScreen
            contrll.modalPresentationStyle  = .overCurrentContext
            contrll.modalTransitionStyle    = .crossDissolve
            penContrll.present(
                contrll,
                animated: true,
                completion: completion
            )
        }
    }
    
    private func addControllerToList(
        managerModel: GHManagerModel,
        parameters: GHBundleParameters?
    ) {
        guard let controller = managerModel.controller, let type = managerModel.type else { return }
        
        controller.bundle             = parameters
        controller.controllerType     = managerModel.type
        controller.viewModel          = managerModel.viewModel
        controller.controllerManager  = self
        
        self.viewControllers.append(
            (type: type, ctrDel: controller)
        )
    }
    
    private func getLastVcPresented() -> (type: Int, ctrDel: GHBaseViewControllerDelegate?)? {
        guard let controller = self.viewControllers.last else {
            return nil
        }
        
        return controller
    }
    
    private func getPenultimateVcPresented() -> (type: Int, ctrDel: GHBaseViewControllerDelegate?)? {
        if self.viewControllers.count > 1 {
            return self.viewControllers[self.viewControllers.count - 2]
        }
        
        return nil
    }
    
    private func releaseVcFromName(type: Int) {
        self.viewControllers.filter { $0.type == type }.first?.ctrDel?.removeReferenceContext()
        
        if let index = self.viewControllers.firstIndex(where: { $0.type == type }) {
            self.viewControllers.remove(at: index)
        }
    }
}
