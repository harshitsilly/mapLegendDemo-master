//
//  FUIMapLegendItem.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/6/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit

enum FUIMapLegendItemType {
    case iconType
    case lineType
    case iconLineType
}

open class FUIMapLegendItem {

    private var title: String
    private var type: FUIMapLegendItemType
    // MARK: - NOTE IF ICON COLOR != LINE COLOR
    private var color: UIColor
    private var icon: FUIMapLegendIcon? = nil
    private var line: FUIMapLegendLine? = nil
    
    
    init(itemTitle title: String, icon givenIcon: FUIMapLegendIcon, line givenLine: FUIMapLegendLine, color givenColor: UIColor) {
        self.title = title
        self.type = .iconLineType
        self.color = givenColor
        self.icon = givenIcon
        self.line = givenLine
    }
    
    init(itemTitle title: String, icon givenIcon: FUIMapLegendIcon, color givenColor: UIColor) {
        self.title = title
        self.type = .iconType
        self.color = givenColor
        self.icon = givenIcon
    }
    
    init(itemTitle title: String, line givenLine: FUIMapLegendLine, color givenColor: UIColor) {
        self.title = title
        self.type = .lineType
        self.color = givenColor
        self.line = givenLine
    }
    
    func getLineLayer() -> CAShapeLayer? {
        return self.line?.getLayer()
    }
    
    func getString() -> NSAttributedString? {
        return self.icon?.getString()
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getColor() -> UIColor {
        return self.color
    }
}
