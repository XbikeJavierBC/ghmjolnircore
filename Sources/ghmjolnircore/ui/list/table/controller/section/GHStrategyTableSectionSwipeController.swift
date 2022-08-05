//
//  File.swift
//  
//
//  Created by Javier Carapia on 05/08/22.
//

import UIKit

public protocol GHStrategyTableSectionSwipeControllerDelegate: GHStrategyTableControllerDelegate {
    func modelSwipeSelected(model: GHModelSimpleTableDelegate, position: Int)
    func canEditRowAt(model: GHModelSimpleTableDelegate, position: Int) -> Bool
}

public extension GHStrategyTableSectionSwipeControllerDelegate {
    func canEditRowAt(model: GHModelSimpleTableDelegate, position: Int) -> Bool {
        return true
    }
}

public class GHStrategyTableSectionSwipeController: GHStrategyTableSectionController {
    private var swipeDelegate: GHStrategyTableSectionSwipeControllerDelegate? {
        return self.delegate as? GHStrategyTableSectionSwipeControllerDelegate
    }
    
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let data = self.filteredListSource?[indexPath.section].listSection?[indexPath.row] {
            let deleteButton = UIContextualAction(style: .destructive, title: data.titleSwipe) { _,_,_ in
                self.swipeDelegate?.modelSwipeSelected(model: data, position: indexPath.row)
            }
            
            if let image = data.imageSwipe {
                deleteButton.image = image
                deleteButton.backgroundColor = .white
            }
            
            return UISwipeActionsConfiguration(
                actions: [deleteButton]
            )
        }
        
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let data = self.filteredListSource?[indexPath.section].listSection?[indexPath.row] {
            return self.swipeDelegate?.canEditRowAt(model: data, position: indexPath.row) ?? false
        }
        
        return false
    }
}
