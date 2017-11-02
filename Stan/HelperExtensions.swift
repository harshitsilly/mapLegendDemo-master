//
//  HelperExtensions.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/20/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit




extension NSLayoutManager {
    
    var fullGlyphRange: NSRange {
        return NSMakeRange(0, numberOfGlyphs)
    }
    
    var fullCharacterRange: NSRange {
        if let textStorage = self.textStorage {
            return NSMakeRange(0, textStorage.length)
        }
        return NSMakeRange(0, 0)
    }
    
    var numberOfLines: Int {
        
        var lineCount = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            self.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            lineCount = lineCount + 1
        }
        return lineCount
    }
    
    var isMultiline: Bool {
        var lineCount = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            self.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            lineCount = lineCount + 1
            if lineCount > 1 {
                return true
            }
        }
        return false
    }
    
    var firstBaselineHeight: CGFloat {
        
        guard textStorage!.length > 0 else { return 0 }
        var lineRange:NSRange = NSRange()
        
        let lineRect = self.lineFragmentRect(forGlyphAt: 0, effectiveRange: &lineRange)
        let attrString: NSAttributedString = textStorage!.attributedSubstring(from: lineRange)
        
        var maxDescender: CGFloat = 0.0 // negative number, should minimize
        var maxLineHeight: CGFloat = 0.0 // positive number, should maximize
        
        for i in 0..<lineRange.length {
            var effectiveRange: NSRange = NSRange()
            let attr = attrString.attributes(at: i, effectiveRange: &effectiveRange)
            
            if let font: UIFont = attr[NSAttributedStringKey.font] as? UIFont {
                
                maxLineHeight = max(maxLineHeight, font.lineHeight)
                maxDescender = min(maxDescender, font.descender)
            }
            
            // check if the end of these attributes extend beyond the first line
            // if yes, then we can stop testing
            if i + effectiveRange.length > lineRange.length {
                break
            }
        }
        
        let firstBaseline = min(lineRect.height, maxLineHeight) + maxDescender
        return firstBaseline
    }
    
    var firstCapHeight: CGFloat {
        
        guard textStorage!.length > 0 else { return 0 }
        var lineRange:NSRange = NSRange()
        
        let _ = self.lineFragmentRect(forGlyphAt: 0, effectiveRange: &lineRange)
        let attrString: NSAttributedString = textStorage!.attributedSubstring(from: lineRange)
        
        var minCapHeight: CGFloat = 1000
        
        for i in 0..<lineRange.length {
            var effectiveRange: NSRange = NSRange()
            let attr = attrString.attributes(at: i, effectiveRange: &effectiveRange)
            
            if let font: UIFont = attr[NSAttributedStringKey.font] as? UIFont {
                
                minCapHeight = min(minCapHeight, font.ascender - font.capHeight)
            }
            
            // check if the end of these attributes extend beyond the first line
            // if yes, then we can stop testing
            if i + effectiveRange.length > lineRange.length {
                break
            }
        }
        
        return minCapHeight
    }
}

extension CGSize {
    func toRect() -> CGRect {
        return CGRect(origin: .zero, size: self)
    }
    
    var midY: CGFloat {
        return self.height / 2
    }
}

extension UIView {
    var boundsInsetMargins: CGSize {
        return CGSize(width: bounds.width - layoutMargins.horizontal, height: bounds.height - layoutMargins.vertical)
    }
    
    func isRegularHorizontalSizeClass(forWidth width: CGFloat) -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                if width > 640 {
                    return true
                }
            default:
                return false
            }
            
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            return width > 627
        }
        return false
    }
    
    func parentViewController() -> UIViewController? {
        guard self.next != nil else { return nil }
        
        var testResponder: UIResponder = self.next!
        
        while !(testResponder is UIViewController) {
            guard testResponder.next != nil else { return nil }
            testResponder = testResponder.next!
        }
        return testResponder as? UIViewController
    }
}

extension UITableViewCell {
    
    func optParentUITableView() -> UITableView? {
        guard self.superview != nil else { return nil }
        
        var testView: UIView = self.superview!
        
        while !(testView is UITableView) {
            guard testView.superview != nil else { return nil }
            testView = testView.superview!
        }
        return testView as? UITableView
    }
    
    internal func widthForAccessoryView() -> CGFloat {
        
        guard self.accessoryView == nil else {
            return self.accessoryView!.bounds.width
        }
        
        switch accessoryType {
        case .checkmark:
            return 24
        case .disclosureIndicator:
            return 17
        case .detailButton:
            return 32
        case .detailDisclosureButton:
            return 52
        case .none:
            return 0
        }
    }
}

extension UIEdgeInsets {
    
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}

