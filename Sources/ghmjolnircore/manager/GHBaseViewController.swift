//
//  GHBaseViewController.swift
//  AMChatMain
//
//  Created by Javier Carapia on 03/09/21.
//

import UIKit

open class GHBaseViewController: UIViewController, GHBaseViewControllerDelegate {
    public var bundle: GHBundleParameters?
    public var controllerType: Int?
    public var viewModel: GHBaseViewModelProtocol?
    public var controllerManager: GHManagerController?
}
