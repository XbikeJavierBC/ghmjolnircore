//
//  File.swift
//
//
//  Created by Javier Carapia on 12/04/22.
//

import UIKit

public protocol GHStrategyNetflixTableSectionControllerDelegate: AnyObject {
    func sectionDisplay(section: Int, model: GHModelNetflixTableDelegate)
    func modelSelected(model: GHModelNetflixTableDelegate, position: Int)
}

public extension GHStrategyNetflixTableSectionControllerDelegate {
    func sectionDisplay(section: Int, model: GHModelNetflixTableDelegate) { }
    func modelSelected(model: GHModelNetflixTableDelegate, position: Int) { }
}

public class GHStrategyNetflixTableSectionController: UITableViewController {
    weak var itemDelegate: GHStrategyCollectionControllerDelegate?
    
    internal var listSource: [GHModelNetflixTableDelegate]?
    internal var filteredListSource: [GHModelNetflixTableDelegate]?
    
    private var customView: ViewListener?
    private var heightForHeader: CGFloat = 0.0
    private var sectionViewList: [Int: UIView] = [:]
    private var doingScroll = false
    
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    
    public typealias ViewListener = (String) -> UIView?
    
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
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GHNetflixTableViewCellDelegate?
        
        if let data = self.filteredListSource?[indexPath.section] {
            cell = data.cellForTableView(tableView: tableView, atIndexPath: indexPath)
            cell?.bind(model: data, delegate: self.itemDelegate, section: indexPath.section)
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
    /**
     Section Delegates
     */
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
        
        guard let view = self.sectionViewList[section] else {
            if let cv = self.customView?(title) {
                self.sectionViewList[section] = cv
            }
            
            return self.sectionViewList[section]
        }
        
        return view
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let data = self.filteredListSource?[section], data.titleSection.isEmpty {
            return 0.0
        }
        
        return self.heightForHeader
    }

    /**
     *  CUSTOM SOURCE
     */
    func setSource(listSource: [GHModelNetflixTableDelegate]) {
        self.listSource?.removeAll()
        self.listSource = nil
        self.listSource = listSource
        
        self.filteredListSource?.removeAll()
        self.filteredListSource = nil
        self.filteredListSource = listSource
        
        self.tableView.reloadData()
    }
    
    func setFilterSource(closure: ([GHModelNetflixTableDelegate]?) -> [GHModelNetflixTableDelegate]?) {
        self.filteredListSource?.removeAll()
        self.filteredListSource = closure(self.listSource)
        self.tableView.reloadData()
    }
    
    public func getSource() -> [GHModelNetflixTableDelegate]? {
        self.listSource
    }
    
    //MARK: GENERIC FUNCTION
    public func setSectionView(heightSection: CGFloat, viewSection: @escaping ViewListener) {
        self.heightForHeader = heightSection
        self.customView = viewSection
    }
    
    func removeReferenceContext() {
        self.listSource?.removeAll()
        self.listSource = nil
        
        self.filteredListSource?.removeAll()
        self.filteredListSource = nil
        
        self.sectionViewList.removeAll()
        
        self.itemDelegate = nil
    }
}

