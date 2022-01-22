//
//  UINavigationControllerExtesnion.swift
//  LNMainApp
//
//  Created by Javier Carapia on 23/08/21.
//

import UIKit

internal extension UINavigationController {
    /*
     Get previous view controller of the navigation stack.
     - returns:
     El ViewController anterior.
     */
    func previousViewController() -> UIViewController? {
        let length = self.viewControllers.count
        let previousViewController: UIViewController? = length >= 2 ? self.viewControllers[length-2] : nil
        return previousViewController
    }
    
    /// Lanza el pushviewController con un completition.
    ///
    /// - Parameters:
    ///   - viewController: View controller destino.
    ///   - animated: true/false si es animado.
    ///   - completion: El metodo a ejecutar cuando se complete la transaccion.
    func pushViewController(viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /**
     Lanza el pushviewController con un completition.
     */
    func popToViewController(viewController: UIViewController, animated: Bool, completion: (() -> ())? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popToViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    /**
     Lanza el pushviewController con un completition.
     */
    
    func popViewController(animated: Bool, completion: (() -> Void)? = nil){
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
