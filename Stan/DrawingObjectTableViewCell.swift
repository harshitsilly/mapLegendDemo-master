//
//  DrawingObjectTableViewCell.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/17/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import QuartzCore
import SAPFiori

@IBDesignable
class DrawingObjectTableViewCell: UITableViewCell {

    @objc private(set) var objectView: DrawingObjectView = DrawingObjectView(frame: .zero)
    
    /// :nodoc:
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    /// :nodoc:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    internal var isTransitioning: Bool = false
    
    internal lazy var fioriDisclosureIndicator: UIButton = FUIDisclosureIndicator()
    
    internal func initialize() {

        self.addObserver(self, forKeyPath: "objectView.bounds", options: .new, context: nil)
        
        self.contentView.layoutMargins.right = 0
        self.contentView.preservesSuperviewLayoutMargins = true
        self.contentView.addSubview(objectView)
        objectView.translatesAutoresizingMaskIntoConstraints = false
        
        objectView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        objectView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor).isActive = true
        objectView.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        objectView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}
