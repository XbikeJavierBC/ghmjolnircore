//
//  GHGenericCollectionViewController.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHGenericCollectionViewControllerDelegate: AnyObject {
    func itemSelected(model: GHModelCollectionDelegate)
}

public class GHGenericCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    fileprivate var flowLayout: UICollectionViewFlowLayout?
    
    private lazy var listSource: [GHModelCollectionDelegate]? = []
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    
    weak public var collectionDelegate: GHGenericCollectionViewControllerDelegate?
    
    public required init(direction: UICollectionView.ScrollDirection? = nil) {
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout?.scrollDirection = direction ?? .horizontal
        super.init(collectionViewLayout: self.flowLayout!)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nibList.forEach { element in
            let nib = UINib(nibName: element.nibName, bundle: element.bundle)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: element.nibName)
        }
        
        self.collectionView?.backgroundColor = .clear
        
        self.collectionView.clipsToBounds = true
        
        self.collectionView?.isUserInteractionEnabled = true
        self.collectionView?.alwaysBounceVertical = false
        self.collectionView?.alwaysBounceHorizontal = false
        
        self.collectionView?.bounces = true
        
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        
        self.collectionView.contentInset = self.sectionInsets
    }
    
    public override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        self.listSource?.count ?? 0
    }
    
    public override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: GHCollectionViewCellDelegate?
        
        if let data = self.listSource?[indexPath.row] {
            cell = data.collectionView(collectionView: collectionView, cellForItemAt: indexPath)
            cell?.bind(model: data)
        }
        
        guard let collectionCell = cell as? UICollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return collectionCell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if let data = self.listSource?[indexPath.row] {
            self.collectionDelegate?.itemSelected(model: data)
        }
    }
    
    //MARK: DELEGATE FLOW LAYOUT
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let data = self.listSource?[indexPath.row] {
            if data.sizeForItem.width == 0.0 {
                let collettionViewWidth = collectionView.bounds.width
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                let spaceBetweenCells = flowLayout.minimumInteritemSpacing
                let adjustedWidth = collettionViewWidth - spaceBetweenCells
                
                let width = adjustedWidth / 2
                let height = data.sizeForItem.height
                
                return CGSize(width: width, height: height)
            }
            
            return data.sizeForItem
        }
        
        return CGSize.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        9.0
    }
    
    /**
     Data Source
     */
    public func setSource(list: [GHModelCollectionDelegate]) {
        self.listSource?.removeAll()
        self.listSource = nil
        self.listSource = list
        
        self.collectionView?.reloadData()
    }
    
    public func setRegisterNibList(nibList: [(String, Bundle)]) {
        self.nibList = nibList
    }
    
    public func removeReferenceContext() {
        self.listSource?.removeAll()
        self.listSource = nil
        
        self.flowLayout = nil
        
        self.nibList.removeAll()
        
        self.collectionDelegate = nil
    }
}
