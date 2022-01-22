//
//  GHModelDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

//MARK: UITableViewCell
public protocol GHSimpleTableViewCellDelegate {
    func bind(model: GHModelTableDelegate)
}

public protocol GHTableViewCellDelegate: GHSimpleTableViewCellDelegate {
    var genericCollectionView: GHGenericCollectionViewController { get set }
    
    func bind(model: GHModelTableDelegate, delegate: GHGenericCollectionViewControllerDelegate?)
}

public extension GHTableViewCellDelegate where Self: UITableViewCell {
    func bind(model: GHModelTableDelegate, delegate: GHGenericCollectionViewControllerDelegate?) {
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
