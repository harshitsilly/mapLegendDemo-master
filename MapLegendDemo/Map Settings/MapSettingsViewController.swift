//
//  MapSettingsViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/24/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class MapSettingsViewController: UITableViewController {
    
    var dataSource: MapSettingsDataSource = MapSettingsDataSource()
    
    override convenience init(style: UITableViewStyle) {
        self.init(style: .grouped)
    }
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissVC))
        self.navigationController?.title = "Map Settings"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsCell = tableView.dequeueReusableCell(withIdentifier: "value2", for: indexPath)
        settingsCell.textLabel?.text = dataSource.data[indexPath.section]
        if dataSource.data[indexPath.section] == "Near Me Radius" {
            var switchView = UISwitch()
            settingsCell.accessoryView = switchView
        } else {
            settingsCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        return settingsCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }

}
