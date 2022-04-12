//
//  GHModelDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

//MARK: Simple UITableViewCell
public protocol GHSimpleTableViewCellDelegate {
    func bind(model: GHModelSimpleTableDelegate)
    func bind(model: GHModelSimpleTableDelegate, cellDelegate: GHStrategyTableViewCellDelegate?)
}

public extension GHSimpleTableViewCellDelegate {
    func bind(model: GHModelSimpleTableDelegate) {
        
    }
    
    func bind(model: GHModelSimpleTableDelegate, cellDelegate: GHStrategyTableViewCellDelegate?) {
        self.bind(model: model)
    }
}
