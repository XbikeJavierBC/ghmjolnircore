//
//  GHTableCellDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHModelTableDelegate {
    var reuseIdentifier: String { get }
    
    var titleSection: String? { get set }
    var heightForRow: CGFloat { get }
    var bundle: Bundle? { get }
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHTableViewCellDelegate?
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
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHTableViewCellDelegate? {
        var cell = tableView.dequeueReusableCell(
            withIdentifier: self.reuseIdentifier,
            for: atIndexPath
        ) as? GHTableViewCellDelegate
        
        if cell == nil {
            let nib = self.bundle?.loadNibNamed(
                self.reuseIdentifier,
                owner: tableView,
                options: nil
            )
            cell = nib?[0] as? GHTableViewCellDelegate
        }
        
        return cell
    }
}
