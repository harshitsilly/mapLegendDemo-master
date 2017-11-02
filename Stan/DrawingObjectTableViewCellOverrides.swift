//
//  DrawingObjectTableViewCellOverrides.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/7/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

extension DrawingObjectTableViewCell {
    
    /// :nodoc:
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let keyPath = keyPath, let change = change, let _ = change[.newKey] {
            switch keyPath {
            case "objectView.bounds":
                if isTransitioning {
                    self.objectView.calculateLayouts(objectView.bounds.size)
                }
            default:
                break
            }
        }
        
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    /// :nodoc:
    override open var accessoryType: UITableViewCellAccessoryType {
        get {
            return super.accessoryType
        }
        set {
            super.accessoryType = newValue
            
            switch newValue {
            case .none:
                self.accessoryView = nil
            case .checkmark, .detailButton, .detailDisclosureButton:
                self.objectView.isStatusForcedToCenterYAlignment = true
            case .disclosureIndicator:
                self.accessoryView = self.fioriDisclosureIndicator
                self.accessoryView?.isAccessibilityElement = true
                self.accessoryView?.accessibilityIdentifier = #keyPath(DrawingObjectTableViewCell.accessoryView)
            }
        }
    }
    
    /// :nodoc:
    override func layoutSubviews() {
        super.layoutSubviews()
        //
        if self.accessoryType == .disclosureIndicator, objectView.isMultiline {
            if let accessoryView = self.accessoryView {
                let baselineOffset = objectView.mainManager.firstBaselineHeight
                accessoryView.frame.origin.y =  self.layoutMargins.top + baselineOffset - accessoryView.bounds.height
            }
        }
    }
    
    /// :nodoc:
    override open func willTransition(to state: UITableViewCellStateMask) {
        
        self.isTransitioning = true
        super.willTransition(to: state)
        
        //in switching back from edit mode to normal mode in clicking the "done" button on the nav bar
        //there's an animation moving chevron image in the center to the top (based-line aligned to titleLabel)
        if self.accessoryView != nil && self.accessoryType == .disclosureIndicator && self.objectView.isMultiline {
            let baselineOffset = objectView.mainManager.firstBaselineHeight
            self.accessoryView!.frame.origin.y =  self.layoutMargins.top + baselineOffset - accessoryView!.bounds.height
        }
    }
    
    /// :nodoc:
    override func didTransition(to state: UITableViewCellStateMask) {
        self.isTransitioning = false
        super.didTransition(to: state)
    }
    
    /// :nodoc:
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.invalidateIntrinsicContentSize()
        setNeedsUpdateConstraints()
    }
    
    /// :nodoc:
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.layoutIfNeeded()
        let size = objectView.systemLayoutSizeFitting(objectView.bounds.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        
        return CGSize(width: size.width, height: size.height + contentView.layoutMargins.vertical)
    }
    
    /// :nodoc:
    override func prepareForReuse() {
        super.prepareForReuse()
        objectView.calculateLayoutsCount = 0
        objectView.mainManager.refreshHiddenLinesCounter = 0
        objectView.maxHeight = 22
        objectView.isStatusForcedToCenterYAlignment = false
        objectView.setNeedsLayout()
    }
    
    /// :nodoc:
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layoutSubviews()
        self.objectView.prepareForInterfaceBuilder()
        self.accessoryView?.isHidden = false
        self.layoutIfNeeded()
    }
    
}
