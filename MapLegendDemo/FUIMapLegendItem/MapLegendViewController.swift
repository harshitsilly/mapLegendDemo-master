//
//  MapLegendViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/20/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class MapLegendViewController: UIViewController {
    var tvc: FUIMapLegendTableViewController? = nil
    var tableWidth: CGFloat = 0
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    var headerHeight: CGFloat = 0
    var headerView: UIView? = nil
    private var tvcTable: UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "$ContainerView"
        setTVC()
        setupHeaderView()
        setupLegendTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (isPhone()) {
            let tv = tvc?.tableView
            tv?.isScrollEnabled = (tv?.contentSize.height)! > spec.mapLegendMaxTableHeight - headerHeight
        }
    }
    
    func setupHeaderView() {
        let headerFrame = CGRect(x: 0, y: 0, width: (tvcTable?.bounds.width)!, height: 0)
        headerView = FUIMapLegendHeaderView(withFrame: headerFrame, withHeaderTitle: spec.mapLegendHeaderTitle, withTableWidth: (tvc?.tableWidth)!).view
        headerView?.sizeToFit()
        view.addSubview(headerView!)
        headerView?.accessibilityIdentifier = "$HeaderView"
        headerView?.translatesAutoresizingMaskIntoConstraints = false
        headerView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView?.heightAnchor.constraint(equalToConstant: (headerView?.frame.height)!).isActive = true
        headerView?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        headerView?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        self.headerHeight = (headerView?.frame.height)!
    }
    
    func setupLegendTable() {
        let legendTableFrame = CGRect(x: (headerView?.frame.minX)!, y: (headerView?.frame.maxY)!, width: (tvc?.tableWidth)!, height: UIScreen.main.bounds.height - (headerView?.frame.height)!)
        view.addSubview(tvcTable!)
        tvcTable?.accessibilityIdentifier = "$LegendTableView"
        tvcTable?.translatesAutoresizingMaskIntoConstraints = false
        tvcTable?.topAnchor.constraint(equalTo: (headerView?.bottomAnchor)!).isActive = true
        tvcTable?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tvcTable?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tvcTable?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tvcTable?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
        tvcTable?.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
    }
    
    func setTVC() {
        let storyboard : UIStoryboard = UIStoryboard(name: "MapLegendTableViewController", bundle: nil)
        tvc = (storyboard.instantiateViewController(withIdentifier: "storyBoard") as! FUIMapLegendTableViewController)
        tvcTable = tvc?.tableView
    }
    
    @objc func didPressCancelButton(_ button: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredContentSize: CGSize {
        get {
            tvc?.tableView.layoutIfNeeded()
            let tableViewHeight = tvc?.tableView.contentSize.height
            let preferredHeight = tableViewHeight! + self.headerHeight
            return CGSize(width: tableWidth, height: preferredHeight)
        }
        set {}
    }
    
}
