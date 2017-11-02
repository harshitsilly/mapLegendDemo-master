//
//  DrawingObjectView_FUIObject.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/7/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori

extension DrawingObjectView: FUIObject {
    
    @IBInspectable
    var detailImage: UIImage? {
        get {
            return detailImageView.image
        }
        set {
            detailImageView.image = newValue
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    @IBInspectable
    var headlineText: String? {
        get {
            return headlineLabel.text
        }
        set {
            headlineLabel.text = newValue
            needsRefreshMainAttributedString = true
        }
    }
    @IBInspectable
    var subheadlineText: String? {
        get {
            return subheadlineLabel.text
        }
        set {
            subheadlineLabel.text = newValue
            needsRefreshMainAttributedString = true
        }
    }
    @IBInspectable
    var footnoteText: String? {
        get {
            return footnoteLabel.text
        }
        set {
            footnoteLabel.text = newValue
            needsRefreshMainAttributedString = true
        }
    }
    @IBInspectable
    var descriptionText: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
            needsRefreshAttributedString = true
        }
    }
    @IBInspectable
    var statusText: String? {
        get {
            return statusLabel.text
        }
        set {
            statusLabel.text = newValue
            needsRefreshAttributedString = true
        }
    }
    
    @IBInspectable
    var statusImage: UIImage? {
        get {
            return statusImageView.image
        }
        set {
            statusImageView.image = newValue
        }
    }
    
    @IBInspectable
    var substatusText: String?{
        get {
            return substatusLabel.text
        }
        set {
            substatusLabel.text = newValue
            needsRefreshAttributedString = true
        }
    }
    
    @IBInspectable
    var substatusImage: UIImage? {
        get {
            return substatusImageView.image
        }
        set {
            substatusImageView.image = newValue
        }
    }
    
}
