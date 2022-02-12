//
//  GHModelDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

//MARK: Simple UITableViewCell
public protocol GHSimpleTableViewCellDelegate {
    func bind(model: GHModelTableDelegate)
}

//MARK: Netflix UITableViewCell
public protocol GHTableViewCellDelegate: GHSimpleTableViewCellDelegate {
    var genericCollectionView: GHStrategyCollectionController { get set }
    
    func bind(model: GHModelTableDelegate, delegate: GHStrategyCollectionControllerDelegate?)
}

public extension GHTableViewCellDelegate where Self: UITableViewCell {
    func bind(model: GHModelTableDelegate, delegate: GHStrategyCollectionControllerDelegate?) {
        if self.genericCollectionView.collectionDelegate == nil {
            self.genericCollectionView.collectionDelegate = delegate
        }
        
        self.bind(model: model)
    }
}

//MARK: UICollectionViewCell
public protocol GHCollectionViewCellDelegate {
    func bind(model: GHModelCollectionDelegate)
}
