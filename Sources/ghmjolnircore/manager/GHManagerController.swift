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
    
    public init(navBar: UINavigationController?) {
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
    
    public func presentDangerNavigationViewController(controller: GHBaseViewControllerDelegate) {
        if let index = self.viewControllers.firstIndex(where: { type(of: $0) == type(of: controller) }) {
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
        type: Int,
        controller: GHBaseViewControllerDelegate,
        bundle: GHBundleParameters? = nil,
        viewModel: GHBaseViewModelProtocol? = nil,
        completion: (() -> Void)? = nil
    ) {
        self.viewControllers.forEach { self.releaseVcFromName(type: $0.type) }
        
        self.presentNavigationViewController(
            type: type,
            controller: controller,
            bundle: bundle,
            viewModel: viewModel,
            completion: completion
        )
    }
    
    public func presentNavigationViewController(
        type: Int,
        controller: GHBaseViewControllerDelegate,
        bundle: GHBundleParameters? = nil,
        viewModel: GHBaseViewModelProtocol? = nil,
        completion: (() -> Void)? = nil
    ) {
        if self.viewControllers.firstIndex(where: { $0.type == type }) == nil {
            self.addControllerToList(
                type: type,
                controller: controller,
                bundle: bundle,
                viewModel: viewModel
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
    
    public func presentPopUpViewController(type: Int,
                                           controller: GHBaseViewControllerDelegate,
                                           bundle: GHBundleParameters? = nil,
                                           viewModel: GHBaseViewModelProtocol? = nil,
                                           completion: (() -> Void)? = nil) {
        if self.viewControllers.firstIndex(where: { $0.type == type }) == nil {
            self.addControllerToList(
                type: type,
                controller: controller,
                bundle: bundle,
                viewModel: viewModel
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
        type: Int,
        controller: GHBaseViewControllerDelegate,
        bundle: GHBundleParameters?,
        viewModel: GHBaseViewModelProtocol?
    ) { 
        controller.bundle             = bundle
        controller.controllerType     = type
        controller.viewModel          = viewModel
        controller.controllerManager  = self
        
        self.viewControllers.append((type: type, ctrDel: controller))
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
