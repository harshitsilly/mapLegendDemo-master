//
//  FUIMapLegendSpec.swift
//  SAPFiori
//
//  Copyright © 2016 - 2017 SAP SE or an SAP affiliate company. All rights reserved.
//
//  No part of this publication may be reproduced or transmitted in any form or for any purpose
//  without the express permission of SAP SE. The information contained herein may be changed
//  without prior notice.
//

import Foundation
import UIKit
import MapKit

// DEMO MODE
/*
 iconsWithLines
 onlyIcons
 onlyLines
 longTxt
 shortTxt
 testScroll
*/
let testMode = "testScroll"

//This is for internal usage
/// :nodoc:
class FUIMapLegendSpec {
    
    // Table View Cell Padding
    var mapLegendCellTopPadding: CGFloat { get {return 12}}
    var mapLegendCellBottomPadding: CGFloat { get {return mapLegendCellTopPadding}}
    var mapLegendCellLeftPadding: CGFloat { get {return 16}}
    var mapLegendCellRightPadding: CGFloat { get {return mapLegendCellLeftPadding}}
    
    // Icon Padding
    var mapLegendIconRightPadding: CGFloat { get {return 16}}
    var mapLegendIconStackSpacing: CGFloat { get {return 8}}
    var mapLegendIconViewLength: CGFloat { get {return 28}}
    
    // Line View Spec
    var mapLegendLineWidth: CGFloat { get {return 28}}
    var mapLegendLineHeight: CGFloat { get {return 3}}
    
    // Legend Header
    var mapLegendHeaderTitle: String { get {return "Map Legend"}}
    var longTitle: String { get {return "This is a long title This is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long titleThis is a long title"}}
    var mapLegendMaxTableWidth: CGFloat { get {return 550}}
    var mapLegenedMinTableWidth: CGFloat { get {return 160}}
    var mapLegendMaxTableHeight: CGFloat { get {return 259}}
    var mapLegendMinTableHeight: CGFloat { get {return 103}}
    var mapLegendLandscapeTableWidth: CGFloat { get {return 320}}
    
    var mapLegendHeaderEmptyViewHeight: CGFloat { get {return 12}}
    var mapLegendCancelButtonHeight: CGFloat { get  {return 22}}
    var mapLegendCancelButtonWidth: CGFloat { get {return 22}}
    var mapLegendDummyViewWidth: CGFloat { get {return mapLegendCellRightPadding}}
    var mapLegendDummyViewHeight: CGFloat { get {return 8}}
    
    // Font Styling
    var mapLegendDefaultFont: UIFont { get { return UIFont.systemFont(ofSize: 15)}}
    var mapLegendDefaultStrAttributes: NSDictionary { get {return NSDictionary(dictionary: [NSAttributedStringKey.font: mapLegendDefaultFont])}}
    var mapLegendIconFont: UIFont { get {return UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).withSize(12)}}
    var mapLegendIconTextColor: UIColor { get {return UIColor.white}}
    var mapLegendHeaderDefaultStrAttributes: [NSAttributedStringKey: Any] { get {
        let textColor = UIColor(red: 137/255, green: 137/255, blue: 140/255, alpha: 1)
        var attributes = [NSAttributedStringKey: Any]()
        attributes[.font] = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: UIFont.Weight.semibold)
        attributes[.foregroundColor] = textColor
        return attributes
        }}
}

class FUIMapViewSpec {
    var mapLocationCoord = CLLocationCoordinate2DMake(37.424107, -122.166077)
    var mapCoordTitle = "sTaNFUrd"
    var mapCoordSubtitle = "Berkeley is like DA BEST"
    var mapAnnotationGlyph: String? = nil
    var mapAnnotationImage = UIImage(named: "16px_ checkmark")
    //var mapAnnotationImage = UIImage(named: "notification_16px")
    var mapAnnotationImageSelected = UIImage(named: "notification_32px")
}

class FUIMapToolbarSpec {
    var mapToolbarButtonHeight: CGFloat { get {return 48}}
    var mapToolbarButtonWidth: CGFloat { get {return mapToolbarButtonHeight}}
    var mapToolbarStackSpacing: CGFloat { get {return 0}}
    var mapToolbarStackTopPadding: CGFloat { get {return 0}}
    var mapToolbarStackBottomPadding: CGFloat { get {return mapToolbarStackTopPadding}}
    var mapToolbarStackLeftPadding: CGFloat { get {return 0}}
    var mapToolbarStackRightPadding: CGFloat { get {return mapToolbarStackLeftPadding}}
    var mapToolbarBackgroundColorDark: UIColor { get { return UIColor(red: 61/255, green: 71/255, blue: 81/255, alpha: 1.0)}}
    var mapToolbarBackgroundColorLight: UIColor { get {return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)}}
    var mapToolbarTopPadding: CGFloat { get {return 16}}
    var mapToolbarRightPadding: CGFloat { get {return 16}}
}

class FUISearchBarCornerSpec {
    var searchBarCornerTopPadding: CGFloat { get {return 16}}
    var searchBarCornerLeftPadding: CGFloat { get {return 16}}
    var searchBarCornerBottomPadding: CGFloat { get {return 20}}
    var searchBarCornerWidth: CGFloat { get {return 320}}
}

class SearchDragSpec {
    var searchBarDragleftPadding: CGFloat { get {return 0}}
    var searchBarDragrightPadding: CGFloat { get {return searchBarDragleftPadding}}
    var searchBarDragtopPadding: CGFloat { get {return 0}}
    var searchBarDragbottomPadding: CGFloat { get {return searchBarDragtopPadding}}
    var searchHeight: CGFloat { get {return 68}}
    var dragHandleTopPadding: CGFloat { get {return 6}}
    var dragHandleBotttomPadding: CGFloat {get {return dragHandleTopPadding}}
    var dragHandleWidth: CGFloat {get {return 36}}
    var dragHandleHeight: CGFloat {get {return 5}}
}
