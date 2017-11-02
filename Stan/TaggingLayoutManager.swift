//
//  TaggingLayoutManager.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/23/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
class TaggingLayoutManager : NSLayoutManager {
    
    override init() {
        super.init()
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func beginUpdates() {
        isEditingAttributedString = true
    }
    
    public func endUpdates() {
        isEditingAttributedString = false
    }
    
    private var isEditingAttributedString: Bool = false
    var hiddenCharacterRanges: [NSRange] = []
    var truncationIndicatorRanges: [NSRange] = []
    
    
    override func ensureGlyphs(forCharacterRange charRange: NSRange) {
        if charRange.location == 0 {
            refreshHiddenLines()
        }
        super.ensureGlyphs(forCharacterRange: charRange)
    }
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange:glyphsToShow, at:origin)
        
        let c = UIGraphicsGetCurrentContext()!
        c.setStrokeColor(UIColor.clear.cgColor)
        c.setLineWidth(0.5)
        c.setFillColor(UIColor.preferredFioriColor(forStyle: .primary3, background: .lightBackground).cgColor)
        
        textStorage?.enumerateAttribute(.fuiTag, in: characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil), options: [], using: { (value, range, stop) in
            
            if value != nil {
                var glyphRange = self.glyphRange(forCharacterRange:range, actualCharacterRange:nil)
                glyphRange = NSIntersectionRange(glyphsToShow, range)
                
                guard glyphRange.length > 0 else {
                    return
                }
                if let tc = self.textContainer(forGlyphAt:glyphRange.location, effectiveRange:nil, withoutAdditionalLayout:true) {
                    
                    let horizontalPaddingConstant: CGFloat = 3
                    let verticalPaddingConstant: CGFloat = 2
                    
                    var r = self.boundingRect(forGlyphRange:glyphRange, in:tc)
                    r.origin.x += origin.x
                    r.origin.y += origin.y
                    
                    let font = self.textStorage?.attribute(.font, at: glyphRange.location, effectiveRange: nil) as! UIFont
                    let lineHeight = font.lineHeight
                    //                    r.origin.y += (r.height - lineHeight)
                    
                    let targetRect = CGRect(x: r.origin.x - horizontalPaddingConstant,
                                            y: r.origin.y - verticalPaddingConstant,
                                            width: r.width + (2 * horizontalPaddingConstant),
                                            height: lineHeight + (2 * verticalPaddingConstant))
                    
                    let bezierPath =  UIBezierPath(roundedRect: targetRect, cornerRadius: 4)
                    bezierPath.fill()
                    bezierPath.stroke()
                }
            }
        })
    }
    
    var refreshHiddenLinesCounter = 0
}


extension TaggingLayoutManager {
    
    func refreshHiddenLines() {
        
        refreshHiddenLinesCounter += 1
        print("\(#function), counter: \(refreshHiddenLinesCounter)")
        
        
        hiddenCharacterRanges = []
        
        self.textStorage!.enumerateAttribute(.fuiNumberOfLines, in: fullCharacterRange, options: []) { (value, range, stop) in
            if let value = value as? Int, value > 0 {
                var actualCharacterRange = NSRange()
                let glyphRangeWithNumberOfLinesConstraint = glyphRange(forCharacterRange: range, actualCharacterRange: &actualCharacterRange)
                var counter = 0
                enumerateLineFragments(forGlyphRange: glyphRangeWithNumberOfLinesConstraint, using: { (_, _, _, glyphRangeForLineRect, stop) in
                    if counter == value {
                        let characterRangeForLine = self.characterRange(forGlyphRange: glyphRangeForLineRect, actualGlyphRange: nil)
                        let start =  counter > 0 ? characterRangeForLine.location - 1 : characterRangeForLine.location
                        let length = actualCharacterRange.length
                        let shiftedRange = NSMakeRange(start, length)
                        if let intersection = actualCharacterRange.intersection(shiftedRange) {
                            self.hiddenCharacterRanges.append(intersection)
                            self.textStorage?.addAttribute(.fuiIsHidden, value: true, range: intersection)
                        }
                        
                        stop.pointee = true
                    }
                    counter += 1
                })
            }
        }
    }
    
}
extension TaggingLayoutManager: NSLayoutManagerDelegate {

//    override func textContainerChangedGeometry(_ container: NSTextContainer) {
//        super.textContainerChangedGeometry(container)
//        refreshHiddenLines()
//    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int {
        guard !isEditingAttributedString else {
            return 0
        }
        
        let glyphCount = glyphRange.length
        var newProps: UnsafeMutablePointer<NSLayoutManager.GlyphProperty>? = nil
        
        let memSize = Int(MemoryLayout<NSLayoutManager.GlyphProperty>.size * glyphCount)
        newProps = unsafeBitCast(malloc(memSize), to: UnsafeMutablePointer<NSLayoutManager.GlyphProperty>.self)
        memcpy(newProps, props, memSize)
        
        for hiddenRange in hiddenCharacterRanges {
            if let intersectingHiddenRange = hiddenRange.intersection(glyphRange) {
                for i in 0..<intersectingHiddenRange.length {
                    newProps?[i] = .null
                }
            }
        }

        if newProps != nil {
            layoutManager.setGlyphs(glyphs, properties: newProps!, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
            free(newProps)
            return glyphCount
        } else {
            return 0
        }
    }
}
