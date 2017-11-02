//
//  FUIMapLegendTableViewController.swift
//  MapTaskBar
//
//  Created by Takahashi, Alex on 7/5/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

class FUIMapLegendTableViewController: UITableViewController {
    
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    var tableWidth: CGFloat = 0
    let dataSource = FUIMapLegenedDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffectToTable()
        manageResizingTableView()
        manageTableViewContent()
    }
    
    private func addBlurEffectToTable() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.tintColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.tableView.separatorStyle = .none
        blurEffectView.frame = self.tableView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.backgroundView = blurEffectView
        self.tableView.backgroundView?.layer.backgroundColor = UIColor.clear.cgColor
        self.tableView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    private func manageResizingTableView() {
        self.tableView.isScrollEnabled = false
        self.tableWidth = isPhone() ? UIScreen.main.bounds.size.width : calculateTableWidth()
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 300
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = CGSize(width: self.tableWidth, height: self.tableView.contentSize.height)
    }
    
    private func calculateTableWidth() -> CGFloat {
        let padding = spec.mapLegendCellLeftPadding + spec.mapLegendIconViewLength + spec.mapLegendIconRightPadding + spec.mapLegendCellRightPadding
        let maxWidth: CGFloat = spec.mapLegendMaxTableWidth
        let minWidth: CGFloat = spec.mapLegenedMinTableWidth
        var curWidth: CGFloat = 0
        
        var stringList: [NSString] = []
        for item in dataSource.data! {
            let itemTitel = item.getTitle()
            stringList.append(itemTitel as NSString)
        }
        
        for str in stringList {
            let strWidth = calculateWidthOfString(withString: str)
            if strWidth > curWidth {
                curWidth = strWidth
            }
        }
        curWidth += padding
        
        if (curWidth > minWidth && curWidth < maxWidth) {
            return ceil(curWidth)
        } else {
            return (curWidth >= maxWidth) ? maxWidth : minWidth
        }
    }
    
    private func calculateWidthOfString(withString str: NSString) -> CGFloat {
        let strAttributes = NSDictionary(dictionary: spec.mapLegendDefaultStrAttributes)
        let textSize = str.size(withAttributes: strAttributes as? [NSAttributedStringKey : Any])
        return ceil(textSize.width)
    }

    private func manageTableViewContent() {
        self.tableView.allowsSelection = false
        self.tableView.register(FUIMapLegendItemTableViewCell.self, forCellReuseIdentifier: FUIMapLegendItemTableViewCell.reuseIdentifier)
    }
    
    // MARK: - DATASOURCE
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.data!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: FUIMapLegendItemTableViewCell.reuseIdentifier, for: indexPath) as! FUIMapLegendItemTableViewCell
        itemCell.mapItem = dataSource.data?[indexPath.row]
        return itemCell
    }
}
