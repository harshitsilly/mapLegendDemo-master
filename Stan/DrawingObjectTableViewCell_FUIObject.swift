//
//  DrawingObjectTableViewCell_FUIObject.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/7/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori

extension DrawingObjectTableViewCell : FUIObject {
    
    var iconImages: [GlyphImage] {
        get {
            return objectView.iconImages
        }
        set {
            objectView.iconImages = newValue
        }
    }
    
    @IBInspectable
    var detailImage: UIImage? {
        get {
            return objectView.detailImage
        }
        set {
            objectView.detailImage = newValue
        }
    }
    
    @IBInspectable
    var headlineText: String? {
        get {
            return objectView.headlineText
        }
        set {
            objectView.headlineText = newValue
        }
    }
    
    @IBInspectable
    var subheadlineText: String? {
        get {
            return objectView.subheadlineText
        }
        set {
            objectView.subheadlineText = newValue
        }
    }
    
    @IBInspectable
    var footnoteText: String? {
        get {
            return objectView.footnoteText
        }
        set {
            objectView.footnoteText = newValue
        }
    }
    
    @IBInspectable
    var descriptionText: String? {
        get {
            return objectView.descriptionText
        }
        set {
            objectView.descriptionText = newValue
        }
    }
    
    @IBInspectable
    var statusText: String? {
        get {
            return objectView.statusText
        }
        set {
            objectView.statusText = newValue
        }
    }
    
    @IBInspectable
    var substatusText: String? {
        get {
            return objectView.substatusText
        }
        set {
            objectView.substatusText = newValue
        }
    }
    
    @IBInspectable
    var statusImage: UIImage? {
        get {
            return objectView.statusImage
        }
        set {
            objectView.statusImage = newValue
        }
    }
    
    @IBInspectable
    var substatusImage: UIImage? {
        get {
            return objectView.substatusImage
        }
        set {
            objectView.substatusImage = newValue
        }
    }
}
