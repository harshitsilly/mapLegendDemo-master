//
//  MapDetailTestingTableViewController.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/6/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

class FUIMapChildViewControllerResizing: UITableViewController {

    private var heightSpec = FUISearchBarCornerSpec()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tableView.isScrollEnabled = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.preferredContentSize = CGSize(width: heightSpec.searchBarCornerWidth, height: self.tableView.contentSize.height)
        NotificationCenter.default.post(name: Notification.Name("preferredContentDidChange"), object: nil)
    }
}

class MapDetailTestingTableViewController: FUIMapChildViewControllerResizing {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FUIMapDetailObjectTableViewCell.self, forCellReuseIdentifier: "MapDetailCell")
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapDetailCell", for: indexPath) as! FUIMapDetailObjectTableViewCell
        cell.objectView.isAdaptiveLayout = false
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.headlineText = DemoText.mapDetailTitle.rawValue
            cell.subheadlineText = DemoText.mapDetailTitleSubhead.rawValue
        case 1:
            cell.headlineText = DemoText.mapDetailTitleLong.rawValue
            cell.subheadlineText = DemoText.mapDetailTitleSubhead.rawValue
        case 2:
            cell.tags = [DemoText.mapDetailTag0.rawValue, DemoText.mapDetailTag1.rawValue]
            cell.subheadlineText = DemoText.mapDetailSubheadShort.rawValue
            cell.footnoteText = DemoText.mapDetailFootnoteShort.rawValue
            cell.statusImage = DemoText.mapDetailStatusImage
            cell.substatusText = DemoText.mapDetailSubStatusText.rawValue
        case 3:
            cell.tags = [DemoText.mapDetailTag0.rawValue, DemoText.mapDetailTag1.rawValue]
            cell.subheadlineText = DemoText.mapDetailSubheadLong.rawValue
            cell.footnoteText = DemoText.mapDetailFootnoteShort.rawValue
        default:
            cell.headlineText = DemoText.mapDetailTitle.rawValue
            cell.subheadlineText = DemoText.mapDetailTitleSubhead.rawValue
        }
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
