//
//  GHGenericSectionTableViewController.swift
//  LNMainApp
//
//  Created by Javier Carapia on 24/08/21.
//

import UIKit

public protocol GHStrategyTableControllerDelegate: AnyObject {
    func itemSelected(model: GHModelTableDelegate)
}

public protocol GHStrategyTableViewCellDelegate: AnyObject {
    func tapView(identifier: Int, data: Any?)
}

public class GHStrategyTableController: UITableViewController {
    internal var listSource: [GHModelTableDelegate]?
    internal var filteredListSource: [GHModelTableDelegate]?
    
    private var customView: ViewListener?
    private var heightForHeader: CGFloat = 0.0
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    
    public typealias ViewListener = (String) -> UIView?
    
    public weak var delegate: GHStrategyTableControllerDelegate?
    public weak var cellDelegate: GHStrategyTableViewCellDelegate?
    
    public init(nibList: [(String, Bundle)]) {
        super.init(style: .plain)
        
        self.nibList = nibList
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nibList.forEach {
            let nib = UINib(nibName: $0.nibName, bundle: $0.bundle)
            self.tableView.register(nib, forCellReuseIdentifier: $0.nibName)
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
        self.tableView.estimatedRowHeight = 5.0
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filteredListSource?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GHSimpleTableViewCellDelegate?
        
        if let data = self.filteredListSource?[indexPath.row] {
            cell = data.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell?.bind(model: data, cellDelegate: self.cellDelegate)
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
        
        if let data = self.filteredListSource?[indexPath.row] {
            self.delegate?.itemSelected(model: data)
        }
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
        
        self.delegate = nil
    }
}
