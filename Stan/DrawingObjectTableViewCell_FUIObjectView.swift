//
//  DrawingObjectTableViewCell_FUIObjectView.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/7/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori

extension DrawingObjectTableViewCell: FUIObjectView {

    var headlineLabel: UILabel {
        return objectView.headlineLabel
    }
    
    var subheadlineLabel: UILabel {
        return objectView.subheadlineLabel
    }
    
    var footnoteLabel: UILabel {
        return objectView.footnoteLabel
    }
    
    var descriptionLabel: UILabel {
        return objectView.descriptionLabel
    }
    
    var statusLabel: UILabel {
        return objectView.statusLabel
    }
    
    var substatusLabel: UILabel {
        return objectView.substatusLabel
    }
    
    var statusImageView: FUIImageView {
        return objectView.statusImageView
    }
    
    var substatusImageView: FUIImageView {
        return objectView.substatusImageView
    }
    
    var detailImageView: FUIImageView {
        return objectView.detailImageView
    }
    
}
