//
//  File.swift
//  
//
//  Created by Javier Carapia on 11/02/22.
//

import UIKit

public protocol GHStrategyTableSwipeControllerDelegate: GHStrategyTableControllerDelegate {
    func modelSwipeSelected(model: GHModelTableDelegate, position: Int)
    func canEditRowAt(model: GHModelTableDelegate, position: Int) -> Bool
}

public extension GHStrategyTableSwipeControllerDelegate {
    func canEditRowAt(model: GHModelTableDelegate, position: Int) -> Bool {
        return true
    }
}

public class GHStrategyTableSwipeController: GHStrategyTableController {
    private var swipeDelegate: GHStrategyTableSwipeControllerDelegate? {
        return self.delegate as? GHStrategyTableSwipeControllerDelegate
    }
    
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if let data = self.filteredListSource?[indexPath.row] {
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
        if let data = self.filteredListSource?[indexPath.row] {
            return self.swipeDelegate?.canEditRowAt(model: data, position: indexPath.row) ?? false
        }
        
        return false
    }
}
