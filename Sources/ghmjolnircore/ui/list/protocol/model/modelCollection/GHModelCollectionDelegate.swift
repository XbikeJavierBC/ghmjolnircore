//
//  GHCollectionCellDelegate.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHModelCollectionDelegate {
    var reuseCollectionIdentifier: String { get }
    
    var sizeForItem: CGSize { get }
    var bundle: Bundle? { get }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> GHCollectionViewCellDelegate?
}

public extension GHModelCollectionDelegate {
    var sizeForItem: CGSize { .zero }
    var bundle: Bundle? { .main }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> GHCollectionViewCellDelegate? {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: self.reuseCollectionIdentifier,
            for: indexPath
        ) as? GHCollectionViewCellDelegate
        
        guard let cell = cell else {
            let nib = self.bundle?.loadNibNamed(
                self.reuseCollectionIdentifier,
                owner: collectionView,
                options: nil
            )
            
            return nib?.first as? GHCollectionViewCellDelegate
        }
        
        return cell
    }
}
