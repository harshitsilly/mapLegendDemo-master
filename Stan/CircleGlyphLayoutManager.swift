//
//  CircleGlyphLayoutManager.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/24/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

class CircleGlyphLayoutManager: NSLayoutManager {
    
    var circleGlyphRanges: [NSRange] = []
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange:glyphsToShow, at:origin)
        
        circleGlyphRanges = []
        
        self.textStorage?.enumerateAttribute(NSAttributedStringKey(rawValue: "com.sap.sdk.glyph.circle"), in: glyphsToShow) {
            value, r, stop in
            if let value = value as? Int, value == 1 {
                circleGlyphRanges.append(r)
            }
        }
        
        if self.circleGlyphRanges.count == 0 {
            return
        } else {
            
            let c = UIGraphicsGetCurrentContext()!
            c.saveGState()
            c.setStrokeColor(UIColor.clear.cgColor)
            c.setLineWidth(0.5)
            c.setFillColor(UIColor.red.cgColor)
            
            for range in circleGlyphRanges {
                var glyphRange = self.glyphRange(forCharacterRange:range, actualCharacterRange:nil)
                glyphRange = NSIntersectionRange(glyphsToShow, range)
                if glyphRange.length == 0 {
                    return
                }
                if let tc = self.textContainer(forGlyphAt:glyphRange.location, effectiveRange:nil, withoutAdditionalLayout:true) {
                    let horizontalPaddingConstant: CGFloat = 5
                    var r = self.boundingRect(forGlyphRange:glyphRange, in:tc)
                    let location = self.location(forGlyphAt: glyphRange.location)
                    self.setLocation(CGPoint(x: r.origin.x + horizontalPaddingConstant, y: location.y), forStartOfGlyphRange: glyphRange)
                    r.origin.x += origin.x + horizontalPaddingConstant
                    r.origin.y += origin.y
                    
                    let bezierPath =  UIBezierPath(roundedRect: CGRect(x: r.origin.x - horizontalPaddingConstant, y: r.origin.y - 2, width: r.width + 2 * horizontalPaddingConstant, height: r.height + 2 * 2), cornerRadius: 4) //[UIBezierPath bezierPathWithRoundedRect:bubbleBounds cornerRadius:15.0];
                    bezierPath.close()
                    //                    bezierPath.move(to: r.origin)
                    bezierPath.fill()
                    bezierPath.stroke()
                }
                
            }
            c.restoreGState()
        }
    }
}
