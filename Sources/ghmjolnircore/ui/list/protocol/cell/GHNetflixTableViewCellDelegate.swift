//
//  File.swift
//  
//
//  Created by Javier Carapia on 12/04/22.
//

import UIKit

//MARK: Netflix UITableViewCell
public protocol GHNetflixTableViewCellDelegate {
    var genericCollectionView: GHStrategyCollectionController { get set }
    
    func bind(model: GHModelNetflixTableDelegate)
    
    func bind(
        model: GHModelNetflixTableDelegate,
        delegate: GHStrategyCollectionControllerDelegate?,
        section: Int
    )
}

public extension GHNetflixTableViewCellDelegate where Self: UITableViewCell {
    func bind(model: GHModelNetflixTableDelegate) {
        print("Foo")
    }
    
    func bind(
        model: GHModelNetflixTableDelegate,
        delegate: GHStrategyCollectionControllerDelegate?,
        section: Int
    ) {
        let row: CGFloat = GHScrollDictionary.sharedInstance.get(section) ?? -15
        
        if self.genericCollectionView.collectionDelegate == nil {
            self.genericCollectionView.collectionDelegate = delegate
        }
        
        self.genericCollectionView.collectionView.contentOffset = CGPoint(x: row, y: 0)
        
        self.bind(model: model)
    }
}
