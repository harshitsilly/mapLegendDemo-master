//
//  FUIMapDetailObjectTableViewCell.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/6/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

class FUIMapDetailObjectTableViewCell: DrawingObjectTableViewCell, FUITaggable {

    var tags: [String] {
        get {
            return objectView.tags
        }
        set {
            objectView.tags = newValue
        }
    }

}



public struct DemoText {
    public init(text: String) {
        
        self.text = text
    }
    public var text: String
}

extension DemoText : RawRepresentable {
    
    /// :nodoc
    public typealias RawValue = String
    
    /// :nodoc
    public init?(rawValue: RawValue) {
        self.text = rawValue
    }
    
    /// :nodoc
    public var rawValue: RawValue {
        return self.text
    }
}

extension DemoText {
    public static let mapDetailTitle = DemoText(text: "VA Palo Alto Health System")
    public static let mapDetailTitleLong = DemoText(text: "VA Palo Alto Health System wraps to two lines headline")
    public static let mapDetailTitleSubhead = DemoText(text: "Medical Center")
    public static let mapDetailTag0 = DemoText(text: "PDM")
    public static let mapDetailTag1 = DemoText(text: "Started")
    public static let mapDetailSubheadShort = DemoText(text: "1000-Hamburg, MECHANIK")
    public static let mapDetailSubheadLong = DemoText(text: DemoText.mapDetailSubheadShort.rawValue + "will expand to wrap")
    public static let mapDetailFootnoteShort = DemoText(text: "Due on 12/31/16")
    public static let mapDetailStatusImage: UIImage = UIImage(named: "sword_16")!// #imageLiteral(resourceName: "star-on_24px")
    public static let mapDetailSubStatusText = DemoText(text: "High")
    
}
