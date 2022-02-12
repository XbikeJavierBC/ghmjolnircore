//
//  GHTableCellDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHModelTableDelegate {
    var reuseIdentifier: String { get }
    
    var titleSection: String? { get }
    var heightForRow: CGFloat { get }
    var bundle: Bundle? { get }
    var titleSwipe: String? { get }
    var imageSwipe: UIImage? { get }
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHSimpleTableViewCellDelegate?
}

public extension GHModelTableDelegate {
    var titleSection: String? {
        nil
    }
    
    var heightForRow: CGFloat {
        0.0
    }
    
    var bundle: Bundle? {
        .main
    }
    
    var titleSwipe: String? {
        nil
    }
    
    var imageSwipe: UIImage? {
        nil
    }
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHSimpleTableViewCellDelegate? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: self.reuseIdentifier,
            for: atIndexPath
        ) as? GHSimpleTableViewCellDelegate
        
        guard let cell = cell else {
            let nib = self.bundle?.loadNibNamed(
                self.reuseIdentifier,
                owner: tableView,
                options: nil
            )
            
            return nib?.first as? GHSimpleTableViewCellDelegate
        }
        
        return cell
    }
}
