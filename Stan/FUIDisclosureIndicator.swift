//
//  FUIDisclosureIndicator.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/7/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

class FUIDisclosureIndicator: UIButton {
    
    convenience init() {
        self.init(frame: .zero)
        initialize()
    }
    
    private func initialize() {
        let accessoryImageView = UIImageView(frame: CGRect(x: Layout.accessoryViewLeftPadding, y: 0, width: Layout.chevronImageWidth, height: Layout.chevronImageHeight))
        accessoryImageView.image = UIImage(named: "disclosure", in: Bundle(identifier: "com.sap.cp.sdk.ios.SAPFiori") , compatibleWith: nil)
        accessoryImageView.tintColor =  UIColor(red: 199.0/255, green: 199.0/255, blue: 204.0/255, alpha: 1.0)
        
        self.bounds  = CGRect(x: 0, y: 0, width: Layout.chevronImageWidth + Layout.accessoryViewLeftPadding, height: Layout.chevronImageHeight)
        for view in subviews {
            view.removeFromSuperview()
        }
        self.addSubview(accessoryImageView)
    }
    
    private struct Layout {
        static let accessoryViewLeftPadding = CGFloat(8.0)
        static let chevronImageWidth = CGFloat(9.0)
        static let chevronImageHeight = CGFloat(14.0)
    }

}
