//
//  GHGenericSectionTableViewController.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHGenericSectionTableViewControllerDelegate: AnyObject {
    func itemSelected(model: GHModelTableDelegate)
}

public class GHGenericSectionTableViewController: UITableViewController {
    public weak var collectionDelegate: GHGenericCollectionViewControllerDelegate?
    public weak var delegate: GHGenericSectionTableViewControllerDelegate?
    
    internal var listSource: [GHModelTableDelegate]?
    internal var filteredListSource: [GHModelTableDelegate]?
    
    public typealias ViewListener = (String) -> UIView?
    private var customView: ViewListener?
    
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    
    private lazy var dcViewHeaders: [String: UIView] = [:]
    private var heightForHeader: CGFloat = 0.0
    private var doingScroll = false
    
    public init(nibList: [(String, Bundle)]) {
        super.init(style: .plain)
        
        self.nibList = nibList
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nibList.forEach { element in
            let nib = UINib(nibName: element.nibName, bundle: element.bundle)
            self.tableView.register(nib, forCellReuseIdentifier: element.nibName)
        }
        
        self.tableView.backgroundColor = .clear
        self.tableView.separatorColor = .clear
        
        self.tableView.clipsToBounds = true
        
        self.tableView.isUserInteractionEnabled = true
        self.tableView.alwaysBounceVertical = false
        
        self.tableView.bouncesZoom = false
        self.tableView.bounces = false
        
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50.0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GHSimpleTableViewCellDelegate?
        
        if let data = self.filteredListSource?[indexPath.section] {
            cell = data.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell?.bind(model: data)
        }
        
        guard let cell = cell as? UITableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let data = self.filteredListSource?[indexPath.section] {
            self.delegate?.itemSelected(model: data)
        }
    }
    
    //MARK: SECTION DELEGATE
    public override func numberOfSections(in tableView: UITableView) -> Int {
        self.filteredListSource?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.filteredListSource?[section].titleSection
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = self.filteredListSource?[section].titleSection else {
            return nil
        }
        
        return self.customView?(title)
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let data = self.filteredListSource?[section], let title = data.titleSection, title.isEmpty {
            return 0.0
        }
        
        return self.heightForHeader
    }

    //MARK: CUSTOM SOURCE
    public func setSource(listSource: [GHModelTableDelegate]) {
        self.listSource?.removeAll()
        self.listSource = nil
        self.listSource = listSource
        
        self.filteredListSource?.removeAll()
        self.filteredListSource = nil
        self.filteredListSource = listSource
        
        self.tableView.reloadData()
    }
    
    public func setFilterSource(closure: ([GHModelTableDelegate]?) -> [GHModelTableDelegate]?) {
        self.filteredListSource?.removeAll()
        self.filteredListSource = closure(self.listSource)
        self.tableView.reloadData()
    }
    
    public func getSource() -> [GHModelTableDelegate]? {
        self.listSource
    }
    
    //MARK: GENERIC FUNCTION
    public func setSectionView(heightSection: CGFloat, viewSection: @escaping ViewListener) {
        self.heightForHeader = heightSection
        self.customView = viewSection
    }
    
    public func removeReferenceContext() {
        self.listSource?.removeAll()
        self.listSource = nil
        
        self.filteredListSource?.removeAll()
        self.filteredListSource = nil
        
        self.dcViewHeaders.removeAll()
        
        self.collectionDelegate = nil
        self.delegate = nil
    }
}
