//
//  GHHelperControllerManager.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

import UIKit

public class GHManagerController {
    private var navigationController: UINavigationController?
    private lazy var viewControllers: [GHBaseViewControllerDelegate?] = []
    
    public init(navBar: UINavigationController?) {
        self.navigationController = navBar
    }
    
    public func setNavBarHiden(hidden: Bool) {
        self.navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    
    public func hideViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let item = self.getLastVcPresented() {
            if let controller = item as? UIViewController {
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
            self.releaseVcFromName(name: item)
        }
    }
    
    public func presentDangerNavigationViewController(controller: GHBaseViewControllerDelegate) {
        if let index = self.viewControllers.firstIndex(where: { type(of: $0) == type(of: controller) }) {
            for (indexCtrl, element) in self.viewControllers.enumerated() {
                if indexCtrl > index {
                    self.releaseVcFromName(name: element)
                }
            }
        }
        
        if let contrll = self.viewControllers.last, let uiController = contrll as? UIViewController {
            self.navigationController?.popToViewController(
                viewController: uiController,
                animated: true
            )
        }
    }
    
    public func presentRootNavigationViewController(controller: GHBaseViewControllerDelegate,
                                             bundle: GHBundleParameters? = nil) {
        self.viewControllers.forEach { self.releaseVcFromName(name: $0) }
        
        self.presentNavigationViewController(
            controller: controller,
            bundle: bundle
        )
    }
    
    public func presentNavigationViewController(controller: GHBaseViewControllerDelegate,
                                         bundle: GHBundleParameters? = nil,
                                         viewModel: GHBaseViewModelProtocol? = nil,
                                         completion: (() -> Void)? = nil) {
        if self.viewControllers.firstIndex(where: { type(of: $0) == type(of: controller) }) == nil {
            self.addControllerToList(
                controller: controller,
                bundle: bundle,
                viewModel: viewModel
            )
        }
        
        if let contrll = self.getLastVcPresented() as? UIViewController {
            self.navigationController?.pushViewController(
                viewController: contrll,
                animated: true,
                completion: completion
            )
        }
    }
    
    public func presentPopUpViewController(controller: GHBaseViewControllerDelegate,
                                    bundle: GHBundleParameters? = nil,
                                    viewModel: GHBaseViewModelProtocol? = nil,
                                    completion: (() -> Void)? = nil) {
        if self.viewControllers.firstIndex(where: { type(of: $0) == type(of: controller) }) == nil {
            self.addControllerToList(
                controller: controller,
                bundle: bundle,
                viewModel: viewModel
            )
        }
        
        if let contrll = self.getLastVcPresented() as? UIViewController,
            let penContrll = self.getPenultimateVcPresented() as? UIViewController {
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
    
    private func addControllerToList(controller: GHBaseViewControllerDelegate,
                                     bundle: GHBundleParameters?,
                                     viewModel: GHBaseViewModelProtocol?) {
        controller.bundle             = bundle
        controller.controllerManager  = self
        controller.viewModel          = viewModel
        
        self.viewControllers.append(controller)
    }
    
    private func getLastVcPresented() -> GHBaseViewControllerDelegate? {
        guard let controller = self.viewControllers.last else {
            return nil
        }
        
        return controller
    }
    
    private func getPenultimateVcPresented() -> GHBaseViewControllerDelegate? {
        if self.viewControllers.count > 1 {
            return self.viewControllers[self.viewControllers.count - 2]
        }
        
        return nil
    }
    
    private func releaseVcFromName(name: GHBaseViewControllerDelegate?) {
        self.viewControllers.filter { type(of: $0) == type(of: name) }.first??.removeReferenceContext()
        
        if let index = self.viewControllers.firstIndex(where: { type(of: $0) == type(of: name) }) {
            self.viewControllers.remove(at: index)
        }
    }
}
