//
//  FUIMapDetailViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/31/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var dragSpec = SearchDragSpec()
    var cornerSpec = FUISearchBarCornerSpec()
    var tableView = UITableView()
    var searchWidth: CGFloat!
    
    var data: [String] = {
        var lst: [String] = []
        var count = 5
        while count > 0 {
            lst.append("Table View Cell: \(count)")
            count -= 1
        }
        return lst
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchWidth = isPhone() ? UIScreen.main.bounds.width - dragSpec.searchBarDragleftPadding - dragSpec.searchBarDragrightPadding : cornerSpec.searchBarCornerWidth
        tableView.backgroundColor = .green
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.accessibilityIdentifier = "$DetailViewTVC"
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = false
        view.addSubview(tableView)
        setTableViewConstraints()
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = CGSize(width: searchWidth, height: self.tableView.contentSize.height)
        NotificationCenter.default.post(name: Notification.Name("preferredContentDidChange"), object: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    
    deinit {
        print("FUIMapDetailViewController DEINIT")
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }

}
