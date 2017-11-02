//
//  DrawingObjectViewOverrides.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/20/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

extension DrawingObjectView {
    
    /// :nodoc:
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: maxHeight)
    }
    
    /// :nodoc:
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
            self.invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
            setNeedsDisplay()
    }

    /// :nodoc:
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        calculateLayouts(targetSize)
        return CGSize(width: targetSize.width, height: maxHeight)
    }
    
    /// :nodoc:
    override func prepareForInterfaceBuilder() {
        self.calculateLayouts(self.bounds.size)
        super.prepareForInterfaceBuilder()
    }
    
}
