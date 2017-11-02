//
//  FUIMapSearchBar.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/27/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//
import UIKit

class FUISearchResultsViewController: UIViewController, UITextFieldDelegate {

    var dataSource: UIViewController? = nil {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ProtocolSet"), object: nil)
        }
    }
    
    var delegate: UIViewController? = nil {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ProtocolSet"), object: nil)
        }
    }
    
    var searchResultsUpdater: UIViewController? = nil {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ProtocolSet"), object: nil)
        }
    }
    
    var searchBarDelegate: UIViewController? = nil {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ProtocolSet"), object: nil)
        }
    }
    
    var searchView: UIView!
    var dragHandle: UIView?
    var searchController: FUISearchController!
    var searchBar: FUISearchBar? = nil
    
    var dragSpec = SearchDragSpec()
    var cornerSpec = FUISearchBarCornerSpec()
    var tableView: UITableView!
    var searchWidth: CGFloat!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("💪TableView contentHeight \(self.tableView.contentSize.height + self.dragSpec.searchHeight)")
        self.preferredContentSize = CGSize(width: self.searchWidth, height: self.tableView.contentSize.height + self.dragSpec.searchHeight)
        NotificationCenter.default.post(name: Notification.Name("preferredContentDidChange"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.accessibilityIdentifier = "$SearchResultsViewController"
        self.view.layoutMarginsGuide.owningView?.accessibilityIdentifier = "$LayoutMarginsGuide"
        self.view.layoutMarginsGuide.owningView?.translatesAutoresizingMaskIntoConstraints = false
        searchWidth = isPhone() ? UIScreen.main.bounds.width - dragSpec.searchBarDragleftPadding - dragSpec.searchBarDragrightPadding : cornerSpec.searchBarCornerWidth
        NotificationCenter.default.addObserver(self, selector: #selector(FUISearchResultsViewController.resizeSearchContainer(notification:)), name: Notification.Name("resizeSearchContainer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        //blurView()
        setupSearchView()
        setupSearchController()
        setupTableView()
    }
    
    @objc func handleRotation() {
        searchController.searchBar.layoutSubviews()
        tableView.layoutIfNeeded()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController?.searchBar.showsBookmarkButton = false
        searchController?.searchBar.showsCancelButton = true
        searchController.searchBar.clipsToBounds = true
    }
    
    func changeSearchBarTextEntryColor() {
        for subView in searchController.searchBar.subviews {
            if subView is UIView {
                subView.accessibilityIdentifier = "$SearchBarViewSubView"
            }
            for subView1 in subView.subviews {
                if subView1.isKind(of: UITextField.self) {
                    subView1.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    
    func getSearchBarSubView() -> UIView{
        for subView in searchController.searchBar.subviews {
            return subView
        }
        print("DANGER ZONE")
        return UIView()
    }
    
    @objc func resizeSearchContainer(notification: Notification){
        
        if let containerView = getContainerView() {

            searchView.addSubview(searchBar!)
            searchBar!.translatesAutoresizingMaskIntoConstraints = false
            searchBar!.topAnchor.constraint(equalTo: searchView.topAnchor).isActive = true
            searchBar!.leadingAnchor.constraint(equalTo: searchView.leadingAnchor).isActive = true
            searchBar!.bottomAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
            searchBar!.trailingAnchor.constraint(equalTo: searchView.trailingAnchor).isActive = true
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchController.view.layoutIfNeeded()
    }
    
    func getContainerView() -> UIView? {
        var containerView: UIView?
        for view in searchController.view.subviews {
            if view is UIView {
                containerView = view as? UIView
                view.accessibilityIdentifier = "$SearchContainerView"
            }
        }
        return containerView
    }
    
    func setupSearchView() {
        // Constraints
        
        let searchFrame = CGRect(x: dragSpec.searchBarDragleftPadding, y: dragSpec.searchBarDragtopPadding, width: searchWidth, height: dragSpec.searchHeight)
        searchView = UIView(frame: searchFrame)
        searchView.accessibilityLabel = "$SearchView"
        searchView.layer.cornerRadius = 10
        searchView.layer.masksToBounds = true
        view.addSubview(searchView)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: dragSpec.searchBarDragtopPadding).isActive = true
        searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: dragSpec.searchBarDragleftPadding).isActive = true
        searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -dragSpec.searchBarDragrightPadding).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: searchFrame.height).isActive = true
        searchView.clipsToBounds = true
    }

    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = delegate as! UITableViewDelegate
        tableView.dataSource = dataSource as! UITableViewDataSource
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.accessibilityIdentifier = "$DetailViewTVC"
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.layoutIfNeeded()
    }
    
    func setupSearchController() {
        searchController = FUISearchController(searchResultsController: nil)
        searchController.view.frame = searchView.frame
        searchController.view.sizeToFit()
        searchController.searchResultsUpdater = searchResultsUpdater as! UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.isActive = false
        searchBar = searchController.searchBar
        searchController.searchBar.frame = searchView.frame
        let searchSubView = getSearchBarSubView()
        searchSubView.frame = searchView.frame
        searchController.searchBar.placeholderText = "Search The List"
        searchController.searchBar.delegate = searchResultsUpdater as! UISearchBarDelegate
        changeSearchBarTextEntryColor()
        searchController.accessibilityLabel = "$SearchController"
        searchController.view.accessibilityLabel = "$SearchController.View"
        searchController.view.frame = CGRect(x: 0, y: 0, width: searchWidth, height: 68)

        // Add the search bar as a subview of the UIView you added above the table view
        searchView.addSubview(searchController.searchBar)
        searchController.searchBar.accessibilityLabel = "$SearchBar"
    }
    
    func blurView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}



