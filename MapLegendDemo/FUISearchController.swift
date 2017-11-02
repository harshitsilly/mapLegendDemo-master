//
//  FUISearchController.swift
//  SAPFiori
//
//  Copyright © 2016 - 2017 SAP SE or an SAP affiliate company. All rights reserved.
//
//  No part of this publication may be reproduced or transmitted in any form or for any purpose
//  without the express permission of SAP SE. The information contained herein may be changed
//  without prior notice.
//

import UIKit
//import SAPCommon

/**
 Fiori style UISearchController. The only difference between `FUISearchController`
 and regular `UISearchController` is the `searchBar`.
 `FUISearchController`'s `searchBar` is `FUISearchBar`.
 
 Developer can add a `FUIBarcodeScanner` to this `FUISearchBar` by setting the
 `isBarcodeScannerEnabled` property of the `FUISearchBar` to true. A barcode scanner
 icon will be displayed at the bookmark icon location of the search bar.
 
 A barcode scanner view will be displayed when the barcode scanner icon is tapped.
 
 Here is an sample code for an UITableViewController to add the `FUISearchBar` to its table view header.
 
 ```swift
 // Instantiate an FUISearchController and configure its properties
 searchController = FUISearchController(searchResultsController: nil)
 searchController.searchResultsUpdater = self
 searchController.hidesNavigationBarDuringPresentation = true
 searchController.searchBar.placeholderText = "Search The List"
 
 // Adding barcode scanner to this search bar
 searchController.searchBar.isBarcodeScannerEnabled = true
 searchController.searchBar.barcodeScanner?.scanMode = .EAN_UPC
 searchController.searchBar.barcodeScanner?.scanResultTransformer = { (scanString) -> String in
 return scanString.uppercased()
 }
 
 self.tableView.tableHeaderView = searchController.searchBar
 
 
 ```
 
 */
open class FUISearchController: UISearchController {
    
    var heightSpec = FUIDragHeightSpec()
    var searchSpec = FUISearchBarCornerSpec()
    fileprivate var _parentNavigationController: UINavigationController?
    
    /// :nodoc:
    override public init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
        self.setup()
    }
    
    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    /// :nodoc:
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.setup()
    }
    
    fileprivate var _searchBar: FUISearchBar? = nil
    
    /**
     Search bar of the search controller.  When instantiating the `FUISearchController` programmatically, a default `FUISearchBar` is initialized automatically and can be used directly.  The developer should set a reference to an `@IBOutlet`, if adding a search bar to their view in Interface Builder.
     */
    override open var searchBar: FUISearchBar {
        
        get {
            guard _searchBar != nil else {
                _searchBar = FUISearchBar()
                _searchBar!.sizeToFit()
                return _searchBar!
            }
            return _searchBar!
        }
    }
    
    private func setup() {
        self.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = false
        self.dimsBackgroundDuringPresentation = false
        self.searchBar.backingDelegate = self
        
        refreshParentController()
        
        // resolves issue where view is loaded in dealloc by SearchController  http://stackoverflow.com/questions/32675001/uisearchcontroller-warning-attempting-to-load-the-view-of-a-view-controller
        self.loadViewIfNeeded()
    }
    
    fileprivate func refreshParentController() {
        if let parentController = UIApplication.shared.keyWindow?.rootViewController {
            
            if parentController is UINavigationController {
                _parentNavigationController = parentController as? UINavigationController
            } else {
                _parentNavigationController = parentController.navigationController
            }
        }
    }
    
    /// :nodoc:
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshParentController()
        _parentNavigationController?.extendedLayoutIncludesOpaqueBars = hidesNavigationBarDuringPresentation
    }
    
    /// :nodoc:
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if view.frame.origin.y < 0 {
            view.frame.origin.y = 68
        }
        var width = isPhone() ? UIScreen.main.bounds.width : searchSpec.searchBarCornerWidth
        view.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: width, height: view.frame.height)
        NotificationCenter.default.post(name: Notification.Name("resizeSearchContainer"), object: nil)
        constrainSearchContainerView()
    }
    
    func constrainSearchContainerView() {
        var containerView: UIView?
        var width = isPhone() ? UIScreen.main.bounds.width : searchSpec.searchBarCornerWidth
        for view in view.subviews {
            if view is UIView {
                containerView = view as? UIView
                view.accessibilityIdentifier = "$SearchContainerView"
                
                view.frame = CGRect(x: 0, y: heightSpec.topBoundaryY + 5, width: width, height: 68)
            }
        }
        self.view.frame = CGRect(x: 0, y: heightSpec.topBoundaryY + 5, width: width, height: 68)
    }
    
}

extension FUISearchController : UISearchBarDelegate {
    
    /// :nodoc:
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return (searchBar as? FUISearchBar)?.developerDelegate?.searchBarShouldBeginEditing?(searchBar) ?? true
    }// return NO to not become first responder
    
    /// :nodoc:
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = true
        
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBarTextDidBeginEditing?(searchBar)
    }// called when text starts editing
    
    /// :nodoc:
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return (searchBar as? FUISearchBar)?.developerDelegate?.searchBarShouldEndEditing?(searchBar) ?? true
    }// return NO to not resign first responder
    
    /// :nodoc:
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBarTextDidEndEditing?(searchBar)
    }// called when text ends editing
    
    /// :nodoc:
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBar?(searchBar, textDidChange: searchText)
    }// called when text changes (including clear)
    
    /// :nodoc:
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return (searchBar as? FUISearchBar)?.developerDelegate?.searchBar?(searchBar, shouldChangeTextIn: range, replacementText: text) ?? true
    }// called before text changes
    
    /// :nodoc:
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBarSearchButtonClicked?(searchBar)
    }// called when keyboard search button pressed
    
    
    /// :nodoc:
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async { [unowned self] in
            self.searchBar.showsCancelButton = false
            if self.isActive {
                self.isActive = false
            }
            (searchBar as? FUISearchBar)?.developerDelegate?.searchBarCancelButtonClicked?(searchBar)
        }
        
    }// called when cancel button pressed
    
    /// :nodoc:
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBarResultsListButtonClicked?(searchBar)
    }// called when search results button pressed
    
    /// :nodoc:
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        (searchBar as? FUISearchBar)?.developerDelegate?.searchBar?(searchBar, selectedScopeButtonIndexDidChange: selectedScope)
    }
}

extension FUISearchController:  UIBarPositioningDelegate  {
    
    /**
     Implement this method on your manual bar delegate when not managed by a UIKit controller.
     UINavigationBar and UISearchBar default to UIBarPositionTop, UIToolbar defaults to UIBarPositionBottom.
     This message will be sent when the bar moves to a window.
     */
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return (bar as? FUISearchBar)?.developerDelegate?.position?(for: bar) ?? .top
    }// UINavigationBarDelegate, UIToolbarDelegate, and UISearchBarDelegate all extend from this
}



