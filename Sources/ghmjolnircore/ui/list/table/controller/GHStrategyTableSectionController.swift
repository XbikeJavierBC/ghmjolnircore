//
//  GHStrategyTableController.swift
//  
//
//  Created by Javier Carapia on 14/02/22.
//

import UIKit

public class GHStrategyTableSectionController: UITableViewController {
    internal var listSource: [GHModelTableSectionDelegate]?
    internal var filteredListSource: [GHModelTableSectionDelegate]?
    
    private var customView: ViewListener?
    private var heightForHeader: CGFloat = 0.0
    private var sectionViewList: [Int: UIView] = [:]
    private lazy var nibList: [(nibName: String, bundle: Bundle)] = []
    
    public typealias ViewListener = (String) -> UIView?
    
    public weak var delegate: GHStrategyTableControllerDelegate?
    
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
        self.filteredListSource?[section].listSection?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GHSimpleTableViewCellDelegate?
        
        if let section = self.filteredListSource?[indexPath.section],
                let data = section.listSection?[indexPath.row] {
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
        
        if let section = self.filteredListSource?[indexPath.section],
                let data = section.listSection?[indexPath.row] {
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
        
        guard let view = self.sectionViewList[section] else {
            if let cv = self.customView?(title) {
                self.sectionViewList[section] = cv
            }
            
            return self.sectionViewList[section]
        }
        
        return view
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let data = self.filteredListSource?[section], let title = data.titleSection, title.isEmpty {
            return 0.0
        }
        
        return self.heightForHeader
    }
    
    override public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let data = self.filteredListSource?[section], let title = data.titleSection, title.isEmpty {
            return 0.0
        }
        
        return self.heightForHeader
    }

    //MARK: CUSTOM SOURCE
    public func setSource(listSource: [GHModelTableSectionDelegate]) {
        self.listSource?.removeAll()
        self.listSource = nil
        self.listSource = listSource
        
        self.filteredListSource?.removeAll()
        self.filteredListSource = nil
        self.filteredListSource = listSource
        
        self.tableView.reloadData()
    }
    
    public func setFilterSource(closure: ([GHModelTableSectionDelegate]?) -> [GHModelTableSectionDelegate]?) {
        self.filteredListSource?.removeAll()
        self.filteredListSource = closure(self.listSource)
        self.tableView.reloadData()
    }
    
    public func getSource() -> [GHModelTableSectionDelegate]? {
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
