//
//  FUIMapLegendDataSource.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/6/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import Foundation
import UIKit
class FUIMapLegenedDataSource {
    
    var data: [FUIMapLegendItem]? = nil
    
    init() {
        createVars()
    }
    
    let longText = "WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT WOW THIS IS LONG TEXT "
    let shortText = "X"
    
    func createItemWithTestMode(itemTitle title: String, withIcon icon: FUIMapLegendIcon, withLine line: FUIMapLegendLine, colored color: UIColor) -> FUIMapLegendItem {
        switch (testMode) {
            case "onlyIcons":
                return FUIMapLegendItem(itemTitle: title, icon: icon, color: color)
            case "iconsWithLines":
                return FUIMapLegendItem(itemTitle: title, icon: icon, line: line, color: color)
            case "onlyLines":
                return FUIMapLegendItem(itemTitle: title, line: line, color: color)
            case "longTxt":
                return FUIMapLegendItem(itemTitle: longText, icon: icon, line: line, color: color)
            case "shortTxt":
                return FUIMapLegendItem(itemTitle: shortText, icon: icon, line: line, color: color)
            default:
                return FUIMapLegendItem(itemTitle: title, icon: icon, line: line, color: color)
        }
    }
    
    func createVars() {
        // DataSource Components
        let jobsTitle = "Jobs"
        let jobsString = "ABC"
        let jobsColor = UIColor.yellow
//        let jobsColor = UIColor(red: 54/255, green: 78/255, blue: 101/255, alpha: 1)
        let jobsIcon = FUIMapLegendIcon(image: UIImage(named: "sword_16")!, color: jobsColor)
        let jobsLine = FUIMapLegendLine(color: jobsColor)
        let jobItem = createItemWithTestMode(itemTitle: jobsTitle, withIcon: jobsIcon, withLine: jobsLine, colored: jobsColor)
        
        let assetsTitle = "Assets"
        let assetsString = "🔥"
        let assetsColor = UIColor(red: 129/255, green: 107/255, blue: 211/255, alpha: 1)
        let assetsIcon = FUIMapLegendIcon(image: UIImage(named: "sword_16")!, text: assetsString, color: assetsColor)
        let assetsLine = FUIMapLegendLine(color: assetsColor, lineDashPattern: [10,8], lineDashPhase: 3.0)
        let assetsItem = createItemWithTestMode(itemTitle: assetsTitle, withIcon: assetsIcon, withLine: assetsLine, colored: assetsColor)
        
        let functionalLocationTitle = "Functional Location"
        let functionalLocationString = "XYZ"
        let functionalLocationColor = UIColor(red: 68/255, green: 169/255, blue: 231/255, alpha: 1)
        let functionalLocationIcon = FUIMapLegendIcon(image: UIImage(named: "sword_16")!, text: functionalLocationString, color: functionalLocationColor)
        let functionalLocationLine = FUIMapLegendLine(color: functionalLocationColor, lineDashPattern: [6,3], lineDashPhase: 3.0)
        let functionalItem = createItemWithTestMode(itemTitle: functionalLocationTitle, withIcon: functionalLocationIcon, withLine: functionalLocationLine, colored: functionalLocationColor)

        let notificationsTitle = "Notifications"
        let notificationsString = "123"
        let notificaitonsColor = UIColor(red: 70/255, green: 164/255, blue: 150/255, alpha: 1)
        let notificationsIcon = FUIMapLegendIcon(image: UIImage(named: "sword_16")!, text: notificationsString, color: notificaitonsColor)
        let notificationsLine = FUIMapLegendLine(color: notificaitonsColor, lineDashPattern: [0,4], lineDashPhase: 3.0)
        let notificationsItem = createItemWithTestMode(itemTitle: notificationsTitle, withIcon: notificationsIcon, withLine: notificationsLine, colored: notificaitonsColor)
        
        if testMode == "testScroll" {
            self.data = [jobItem, assetsItem, functionalItem, notificationsItem, jobItem, jobItem, assetsItem, functionalItem, notificationsItem, jobItem]
            return
        }
        
        if testMode == "ThreeItem" {
            self.data = [jobItem, assetsItem, functionalItem]
//            return
        }
        
        self.data = [jobItem, assetsItem, functionalItem, notificationsItem]
    }
}
