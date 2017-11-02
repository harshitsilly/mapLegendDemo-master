//
//  SearchProtocols.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 8/8/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//
import UIKit

class SearchDataSource {
    var data: [String] = {
        var lst = [String]()
        var count = 30
        while (count > 0) {
            lst += (["Cell Number: \(count)"])
            count -= 1
        }
        return lst
    }()
}

class DevProtocols: UIViewController {
    var container: FUISearchContainerView!
    var fuiSearchResultsVC: FUISearchResultsViewController!
    var givenData = SearchDataSource()
    var filteredSearch = [String]()
    
    init(container containerVC: FUISearchContainerView) {
        super.init(nibName: nil, bundle: nil)
        self.fuiSearchResultsVC = containerVC.searchResultsViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DevProtocols: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fuiSearchResultsVC.searchController.isActive && fuiSearchResultsVC.searchController.searchBar.text != "" {
            return filteredSearch.count
        }
        return givenData.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellItem: String!
        var cell = UITableViewCell()
        cell.selectionStyle = .none
        if fuiSearchResultsVC.searchController.isActive && fuiSearchResultsVC.searchController.searchBar.text != "" {
            cellItem = filteredSearch[indexPath.row]
        } else {
            cellItem = givenData.data[indexPath.row]
        }
        cell.textLabel?.text = cellItem
        return cell
    }
}

extension DevProtocols: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("searchItemSelected"), object: nil)
    }
}

extension DevProtocols: UISearchResultsUpdating, UISearchBarDelegate {
    func filterContentForSearchText(searchText: String) {
        filteredSearch = givenData.data.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }
        fuiSearchResultsVC.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
