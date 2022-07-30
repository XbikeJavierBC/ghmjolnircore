//
//  GHGenericCollectionViewController.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHStrategyCollectionControllerDelegate: AnyObject {
    func itemSelected(model: GHModelCollectionDelegate)
}

public class GHStrategyCollectionController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private var flowLayout: UICollectionViewFlowLayout?
    
    private lazy var listSource: [GHModelCollectionDelegate]? = []
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    private lazy var minimumLineSpacing: CGFloat = 0.0
    private lazy var section = 0
    
    weak public var collectionDelegate: GHStrategyCollectionControllerDelegate?
    
    public init(nibList: [(String, Bundle)], direction: UICollectionView.ScrollDirection? = nil, minimumLineSpacing: CGFloat = 0.0) {
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout?.scrollDirection = direction ?? .horizontal
        
        super.init(collectionViewLayout: self.flowLayout!)
        
        self.nibList = nibList
        self.minimumLineSpacing = minimumLineSpacing
    }
    
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
        
        self.nibList.forEach {
            let nib = UINib(nibName: $0.nibName, bundle: $0.bundle)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: $0.nibName)
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
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if let data = self.listSource?[indexPath.row] {
            if data.sizeForItem.width == .zero {
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
        
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        self.minimumLineSpacing
    }
    
    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        GHScrollDictionary.sharedInstance.add(scrollView.contentOffset.x, key: self.section)
    }
    
    /**
     Data Source
     */
    public func setSource(list: [GHModelCollectionDelegate], section: Int) {
        self.section = section
        
        self.listSource?.removeAll()
        self.listSource = nil
        self.listSource = list
        
        self.collectionView?.reloadData()
    }
    
    public func getDataSource() -> [GHModelCollectionDelegate]? {
        return self.listSource
    }
    
    public func removeReferenceContext() {
        self.listSource?.removeAll()
        self.listSource = nil
        
        self.flowLayout = nil
        
        self.nibList.removeAll()
        
        self.collectionDelegate = nil
    }
}
