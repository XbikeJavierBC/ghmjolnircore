//
//  GHCollectionCellDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHModelCollectionDelegate {
    var reuseIdentifier: String { get }
    
    var sizeForItem: CGSize { get }
    var bundle: Bundle? { get }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> GHCollectionViewCellDelegate?
}

public extension GHModelCollectionDelegate {
    var sizeForItem: CGSize {
        CGSize.zero
    }
    
    var bundle: Bundle? {
        return .main
    }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> GHCollectionViewCellDelegate? {
        var cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseIdentifier,
            for: indexPath
        ) as? GHCollectionViewCellDelegate
        
        if cell == nil {
            let nib = self.bundle?.loadNibNamed(
                self.reuseIdentifier,
                owner: collectionView,
                options: nil
            )
            cell = nib?[0] as? GHCollectionViewCellDelegate
        }
        
        return cell
    }
}
