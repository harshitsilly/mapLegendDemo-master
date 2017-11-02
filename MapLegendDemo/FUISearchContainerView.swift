//
//  FUISearchContainerView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 8/8/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUISearchContainerView: UIView {
    private var searchDragContainer: FUIDragContainer? = nil
    private var detailDragContainer: FUIDragContainer? = nil
    var searchResultsViewController: FUISearchResultsViewController? = nil
    var cornerContainer: FUIResizableCornerView? = nil
    var heightSpec = FUIDragHeightSpec()
    
    var childViewController: UIViewController? = nil {
        didSet {
            setupView()
        }
    }
    
    var parentViewController: UIViewController! {
        didSet {
            setupView()
        }
    }
    
    var isSearchEnabled: Bool? = nil {
        didSet {
            setupView()
        }
    }
    
    init(parentViewController parent: UIViewController) {
        super.init(frame: CGRect.zero)
        NotificationCenter.default.addObserver(self, selector: #selector(FUISearchContainerView.setupView), name: Notification.Name("ProtocolSet"), object: nil)
        searchResultsViewController = FUISearchResultsViewController()
        self.parentViewController = parent
    }
    
    required init?(coder aDecoder: NSCoder) {
        searchResultsViewController = FUISearchResultsViewController()
        super.init(coder: aDecoder)
    }
    
    func setupSearch() {
        if isPhone() {
            searchDragContainer = FUIDragContainer()
            searchDragContainer!.parentVC = parentViewController
            searchDragContainer!.minimalHeight = heightSpec.minSearchHeight
            searchDragContainer!.setupViewContent(childController: searchResultsViewController!)
        } else {
            checkCornerContainer()
            cornerContainer!.accessibilityIdentifier = "$CornerContainer"
            cornerContainer!.searchResultsVC = searchResultsViewController
            cornerContainer!.setupSearchView()
        }
    }
    
    func setupDetail() {
        if isPhone() {
            detailDragContainer = FUIDragContainer()
            detailDragContainer!.parentVC = parentViewController
            detailDragContainer!.setupViewContent(childController: childViewController!)
            detailDragContainer!.minimalHeight = heightSpec.minDetailHeight
            detailDragContainer!.isHidden = false
        } else {
            checkCornerContainer()
            cornerContainer!.setupDetailView(childController: childViewController!)
        }
    }
    
    func checkCornerContainer() {
        if cornerContainer == nil {
            cornerContainer = FUIResizableCornerView()
            cornerContainer!.parentVC = parentViewController
        }
    }
    
    func canSearchInit() -> Bool {
        guard searchDragContainer == nil else {
            return false
        }
        
        guard cornerContainer == nil else {
            return false
        }
        
        if isSearchEnabled != nil {
            if isSearchEnabled! && checkValidProtocols() {
                return true
            }
        }
        return false
    }
    
    func checkValidProtocols() -> Bool{
        guard searchResultsViewController?.dataSource != nil else {
            return false
        }
        guard searchResultsViewController?.delegate != nil else {
            return false
        }
        guard searchResultsViewController?.searchResultsUpdater != nil else {
            return false
        }
        guard searchResultsViewController?.searchBarDelegate != nil else {
            return false
        }
        return true
    }
    
    @objc func setupView() {
        if canDetailInit() {
            setupDetail()
        }
        if canSearchInit() {
            setupSearch()
        }
    }
    
    func canDetailInit() -> Bool {
        guard detailDragContainer == nil else {
            return false
        }
        
        guard parentViewController != nil else {
            return false
        }
        guard childViewController != nil else {
            return false
        }
        return true
    }
    
    deinit {
        NotificationCenter.default.addObserver(self, selector: #selector(FUISearchContainerView.setupView), name:NSNotification.Name(rawValue: "ProtocolSet"), object: nil)
    }
}
