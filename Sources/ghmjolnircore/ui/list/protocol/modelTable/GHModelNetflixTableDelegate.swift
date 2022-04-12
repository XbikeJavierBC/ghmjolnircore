//
//  File.swift
//  
//
//  Created by Javier Carapia on 12/04/22.
//

import UIKit

public protocol GHModelNetflixTableDelegate {
    var titleSection: String { get set }
    var reuseIdentifier: String { get }
    var heightForRow: CGFloat { get }
    var bundle: Bundle? { get }
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHNetflixTableViewCellDelegate?
}

public extension GHModelNetflixTableDelegate {
    var heightForRow: CGFloat { 0.0 }
    var bundle: Bundle? { .main }
    
    func cellForTableView(
        tableView: UITableView,
        atIndexPath: IndexPath
    ) -> GHNetflixTableViewCellDelegate? {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: self.reuseIdentifier,
            for: atIndexPath
        ) as? GHNetflixTableViewCellDelegate
        
        guard let cell = cell else {
            let nib = self.bundle?.loadNibNamed(
                self.reuseIdentifier,
                owner: tableView,
                options: nil
            )
            
            return nib?.first as? GHNetflixTableViewCellDelegate
        }
        
        return cell
    }
}
