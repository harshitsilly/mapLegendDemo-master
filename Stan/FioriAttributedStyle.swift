//
//  FioriAttributedStyle.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/25/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori

enum FUIAttributedStyle {
    static func headline(_ scheme: FUIBackgroundColorScheme = .lightBackground) -> [NSAttributedStringKey: Any] {
        
        var attributes = [NSAttributedStringKey: Any]()
        attributes[.font] = UIFont.preferredFont(forTextStyle: .headline)
        attributes[.foregroundColor] = UIColor.preferredFioriColor(forStyle: .primary1, background: scheme)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineBreakMode = .byWordWrapping
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
 
}
