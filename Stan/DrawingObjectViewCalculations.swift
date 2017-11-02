//
//  DrawingObjectViewCalculations.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/20/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
// MARK: - Calculating subview sizes
internal extension DrawingObjectView {
    
    func iconsOriginXAndPaddedWidth() -> (x: CGFloat, paddedWidth: CGFloat) {
        guard iconsStorage.length > 0 || preserveIconStackSpacing else {
            return (x: 0, paddedWidth: 0)
        }
        
        return (x: 0, paddedWidth: iconsColumnWidth + DrawingObjectView.Dimension.iconsTrailingPad.value)
    }
    
    func iconsAreBaselineAligned() -> Bool {
        guard iconsStorage.length > 1 else {
            return false
        }
        if iconsStorage.attributes(at: 1, effectiveRange: nil).keys.contains(.attachment) {
            return false
        }
        return true
    }
    
    func detailOriginXAndPaddedWidth() -> (x: CGFloat, paddedWidth: CGFloat) {
        guard detailImageView.image != nil || preserveDetailImageSpacing else {
            return (x: iconsXAndPaddedWidth.paddedWidth, paddedWidth: 0)
        }
        let originX: CGFloat = iconsXAndPaddedWidth.x + iconsXAndPaddedWidth.paddedWidth
        return (x: originX, paddedWidth: detailImageViewSize.width + DrawingObjectView.Dimension.detailImageTrailingPad.value)
    }
    
    func statusOriginXAndSize(_ targetSize: CGSize) -> (originX: CGFloat, size: CGSize) {

        guard statusStorage.length > 0 else {
            return (originX: targetSize.width, size: .zero)
        }
        
        let size = statusStorage.size()
        
        return (originX: targetSize.width - size.width, size: size)
    }
    
    func singleLineStatusSize(_ targetSize: CGSize) -> CGSize {
        guard statusStorage.length > 0 else {
            return .zero
        }
        
        let rect2 = statusManager.boundingRect(forGlyphRange: statusManager.fullGlyphRange, in: statusContainer)
        return rect2.size
    }
    
    
    func mainOriginXAndWidth(_ targetSize: CGSize) -> (originX: CGFloat, width: CGFloat) {
        guard self.mainStorage.length > 0 else {
            return (originX: 0, width: 0)
        }
        let originX: CGFloat = detailXAndPaddedWidth.x + detailXAndPaddedWidth.paddedWidth
        if self.horizontalSizeClass == .compact || !isAdaptiveLayout {
            return (originX: originX, width: targetSize.width - originX)
        } else {
            return (originX: originX, width: (targetSize.width * splitPercent) - DrawingObjectView.Dimension.mainTextToSplitTrailingPad.value - originX)
        }
    }
    
    func descriptionOriginXAndWidth(_ targetSize: CGSize) -> (originX: CGFloat, width: CGFloat) {
        guard self.horizontalSizeClass == .regular, isAdaptiveLayout, descriptionStorage.length > 0 else {
            return (originX: 0, width: 0)
        }
        let split = targetSize.width * splitPercent
        return (originX: split + DrawingObjectView.Dimension.descriptionTextToSplitLeadingPad.value, width: statusXAndSize.originX - split - DrawingObjectView.Dimension.descriptionTextToSplitLeadingPad.value - DrawingObjectView.Dimension.descriptionTextToStatusTrailingPad.value)
    }
    
    func applyMainSplit() -> CGRect {
        let mainRect = CGRect(x: mainXAndWidth.originX, y: 0, width: mainXAndWidth.width, height: 3000)
        mainContainer.size = mainRect.size
        return mainManager.boundingRect(forGlyphRange: mainManager.fullGlyphRange, in: mainContainer)
    }
    
    func applyMainExclusionPath() -> CGRect {
        // common to all cases
        let mainRect = CGRect(x: mainXAndWidth.originX, y: 0, width: mainXAndWidth.width, height: 3000)
        //        headlineTextView.textContainer.size = mainRect.size
        mainContainer.size = mainRect.size
        
        guard statusXAndSize.size.width > 0 else {
            return mainManager.boundingRect(forGlyphRange: mainManager.fullGlyphRange, in: mainContainer)
        }
        // common to all where exclusion is required
        let statusExclusionOrigin = CGPoint(x: statusXAndSize.originX - DrawingObjectView.Dimension.statusViewLeadingPad.value - mainXAndWidth.originX, y: 0)
        
        var greatestLocationInMain = 0
        if let _ = headlineRange { greatestLocationInMain = max(greatestLocationInMain, headlineRange!.location) }
        if let _ = subheadlineRange { greatestLocationInMain = max(greatestLocationInMain, subheadlineRange!.location) }
        if let _ = footnoteRange { greatestLocationInMain = max(greatestLocationInMain, footnoteRange!.location) }
        
        if greatestLocationInMain == 0 || isStatusForcedToCenterYAlignment {
            
            // try to size with 100% exclusion in status column
            let tempExclusionSize = CGSize(width: statusXAndSize.size.width + DrawingObjectView.Dimension.statusViewLeadingPad.value, height: 3000)
            let tempExclusionRect = CGRect(origin: statusExclusionOrigin, size: tempExclusionSize)
            let tempIntersectingRect = tempExclusionRect.intersection(mainRect)
            //            headlineTextView.textContainer.exclusionPaths = [UIBezierPath(rect: tempIntersectingRect)]
            mainContainer.exclusionPaths = [UIBezierPath(rect: tempIntersectingRect)]
            
            // if isStatusForcedToCenterYAlignment, we don't care whether this forces mainContainer into multiline
            if isStatusForcedToCenterYAlignment {
                return mainManager.boundingRect(forGlyphRange: mainManager.fullGlyphRange, in: mainContainer)
            }
            
            // otherwise, we check to see if the last character in the first line fragment is the last character of mainStorage
            var tempRange = NSRange()
            let _ = mainManager.lineFragmentRect(forGlyphAt: 0, effectiveRange: &tempRange)
            if tempRange.length == mainManager.fullGlyphRange.length {
                return mainManager.boundingRect(forGlyphRange: mainManager.fullGlyphRange, in: mainContainer)
            }
        }
        
        // or, size with wrapping exclusion around status
        let exclusionSize = CGSize(width: statusXAndSize.size.width + DrawingObjectView.Dimension.statusViewLeadingPad.value, height: statusXAndSize.size.height + DrawingObjectView.Dimension.statusViewBottomPad.value)
        let exclusionRect = CGRect(origin: statusExclusionOrigin, size: exclusionSize)
        let intersectingRect = exclusionRect.intersection(mainRect)
        mainContainer.exclusionPaths = [UIBezierPath(rect: intersectingRect)]
        return mainManager.boundingRect(forGlyphRange: mainManager.fullGlyphRange, in: mainContainer)
    }
    
    func mainOriginY() -> CGFloat {
        if let paragraph = mainStorage.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle{
            return paragraph.paragraphSpacingBefore
        }
        return 0.0
    }
}


