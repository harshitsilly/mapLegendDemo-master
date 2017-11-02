//
//  DrawingObjectViewBackwardsCompatibility.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/20/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit
import SAPFiori

protocol FUIRangeAttributes {
    var numberOfLines: Int { get set }
}

extension FUIRangeAttributes {
    var numberOfLines: Int {
        get {
            return 0
        }
        set {
            assertionFailure("number of lines cannot be stored for this implementation")
        }
    }
}

struct FUITagAttributes: FUIRangeAttributes {
    let isFilled: Bool
    let backgroundScheme: FUIBackgroundColorScheme
}

extension NSAttributedStringKey {
    static let fuiTag = NSAttributedStringKey(rawValue: "com.sap.sdk.string.attribute.tag")
    static let fuiNumberOfLines = NSAttributedStringKey(rawValue: "com.sap.sdk.string.attribute.numberOfLines")
    static let fuiIsHidden = NSAttributedStringKey(rawValue: "com.sap.sdk.string.attribute.isHidden")
    static let fuiGlyphImage = NSAttributedStringKey(rawValue: "com.sap.sdk.glyph.image")
    static let fuiGlyphString = NSAttributedStringKey(rawValue: "com.sap.sdk.glyph.string")
}

extension DrawingObjectView {
    
    func refreshMainAttributedString() {
        self.mainManager.beginUpdates()
        headlineRange = nil
        subheadlineRange = nil
        footnoteRange = nil
        tagRanges = []
        
        
        let buildingAttributedString: NSMutableAttributedString = NSMutableAttributedString()
        var isFirstParagraph: Bool = true
        
        if headlineLabel.text != nil {
            let string = headlineLabel.text!
            var attributes = [NSAttributedStringKey: Any]()
            let headlineAttributes = FUIAttributedStyle.headline(backgroundColorScheme)
            attributes[.font] = headlineLabel.font ?? headlineAttributes[.font]
            attributes[.foregroundColor] = headlineLabel.textColor ?? headlineAttributes[.foregroundColor]
            attributes[.fuiNumberOfLines] = headlineLabel.numberOfLines
            
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = headlineLabel.textAlignment
            paragraphStyle.lineBreakMode = headlineLabel.lineBreakMode
            
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 0
                isFirstParagraph = false
            }
            attributes[.paragraphStyle] = paragraphStyle
            headlineRange = NSMakeRange(mainStorage.length, string.count)
            buildingAttributedString.append(NSAttributedString(string: string, attributes: attributes))
        }
        
        if tags.count > 0 {
            
            let tagsAttributedString = NSMutableAttributedString()
            
            var tagAttributes = [NSAttributedStringKey: Any]()
            tagAttributes[.fuiTag] = FUITagAttributes(isFilled: true, backgroundScheme: backgroundColorScheme)
            tagAttributes[.font] = subheadlineLabel.font ?? UIFont.preferredFont(forTextStyle: .subheadline)
            tagAttributes[.foregroundColor] = UIColor.white
            
            for tag in tags {
                tagsAttributedString.append(NSAttributedString(string: tag, attributes: tagAttributes))
                tagsAttributedString.append(NSAttributedString(string: " ", attributes: [.kern: 12.0]))
            }
            
            var paragraphAttributes = [NSAttributedStringKey: Any]()
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .left
            paragraphStyle.firstLineHeadIndent = 3
            paragraphStyle.headIndent = 3
//            paragraphStyle.lineSpacing = 12
            paragraphStyle.paragraphSpacing = 4
            paragraphStyle.lineBreakMode = .byWordWrapping
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 3
                isFirstParagraph = false
            } else {
                buildingAttributedString.append(NSAttributedString(string: "\n"))
                paragraphStyle.paragraphSpacingBefore = 4
            }
            paragraphAttributes[.paragraphStyle] = paragraphStyle
            
            tagsAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, tagsAttributedString.length))
            
            buildingAttributedString.append(tagsAttributedString)
            
        }
        
        if subheadlineLabel.text != nil {
            let string = subheadlineLabel.text!
            var attributes = [NSAttributedStringKey: Any]()
            attributes[.font] = subheadlineLabel.font ?? UIFont.preferredFont(forTextStyle: .subheadline)
            attributes[.foregroundColor] = subheadlineLabel.textColor ?? .black
            attributes[.fuiNumberOfLines] = subheadlineLabel.numberOfLines
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .left
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 0
                isFirstParagraph = false
            } else {
                buildingAttributedString.append(NSAttributedString(string: "\n"))
                paragraphStyle.paragraphSpacingBefore = 3
            }
            attributes[.paragraphStyle] = paragraphStyle
            subheadlineRange = NSMakeRange(buildingAttributedString.length, string.count)
            buildingAttributedString.append(NSAttributedString(string: string, attributes: attributes))
        }
        
        if footnoteLabel.text != nil {
            let string = footnoteLabel.text!
            var attributes = [NSAttributedStringKey: Any]()
            attributes[.font] = footnoteLabel.font ?? UIFont.preferredFont(forTextStyle: .footnote)
            attributes[.foregroundColor] = footnoteLabel.textColor ?? .darkGray
            attributes[.fuiNumberOfLines] = footnoteLabel.numberOfLines
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .left
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 0
                isFirstParagraph = false
            } else {
                buildingAttributedString.append(NSAttributedString(string: "\n"))
                paragraphStyle.paragraphSpacingBefore = 3
            }
            attributes[.paragraphStyle] = paragraphStyle
            footnoteRange = NSMakeRange(buildingAttributedString.length, string.count)
            buildingAttributedString.append(NSAttributedString(string: footnoteLabel.text!, attributes: attributes))
        }
        
        mainStorage.setAttributedString(buildingAttributedString)
        mainManager.endUpdates()
    }
    
    func refreshAttributedString() {
        
        statusRange = nil
        substatusRange = nil
        
        statusStorage.setAttributedString(NSAttributedString())
        let statusMutableString = NSMutableAttributedString()
        let descriptionMutableString = NSMutableAttributedString()
        
        if descriptionLabel.text != nil {
            var attributes = [NSAttributedStringKey: Any]()
            attributes[.font] = descriptionLabel.font ?? UIFont.preferredFont(forTextStyle: .footnote)
            attributes[.foregroundColor] = descriptionLabel.textColor ?? .darkGray
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .left
            paragraphStyle.paragraphSpacingBefore = 0
            
            attributes[.paragraphStyle] = paragraphStyle
            descriptionMutableString.append(NSAttributedString(string: descriptionLabel.text!, attributes: attributes))
            
        }
        descriptionStorage.setAttributedString(descriptionMutableString)
        
        // recycle parameter for status
        var isFirstParagraph: Bool = true
        
        if statusLabel.text != nil {
            let string = statusLabel.text!
            var attributes = [NSAttributedStringKey: Any]()
            attributes[.font] = statusLabel.font ?? UIFont.preferredFont(forTextStyle: .footnote)
            attributes[.foregroundColor] = statusLabel.textColor ?? .darkGray
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .right
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 0
                isFirstParagraph = false
            }
            
            attributes[.paragraphStyle] = paragraphStyle
            statusRange = NSMakeRange(statusMutableString.length, string.count)
            statusMutableString.append(NSAttributedString(string: string, attributes: attributes))
            
        }
        
        if substatusLabel.text != nil {
            let string = substatusLabel.text!
            var attributes = [NSAttributedStringKey: Any]()
            attributes[.font] = substatusLabel.font ?? UIFont.preferredFont(forTextStyle: .footnote)
            attributes[.foregroundColor] = substatusLabel.textColor ?? .darkGray
            
            let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.alignment = .right
            if isFirstParagraph {
                paragraphStyle.paragraphSpacingBefore = 0
                isFirstParagraph = false
            } else {
                statusMutableString.append(NSAttributedString(string: "\r"))
            }
            
            attributes[.paragraphStyle] = paragraphStyle
            substatusRange = NSMakeRange(statusMutableString.length, string.count)
            statusMutableString.append(NSAttributedString(string: string, attributes: attributes))
        }
        statusStorage.setAttributedString(statusMutableString)
        
        self.needsRefreshAttributedString = false
        self.setNeedsDisplay()
        
    }
    
    func refreshIconImages() {
        let iconStrings = NSMutableAttributedString()
        for (index, item) in iconImages.enumerated() {
            
            let attributedText = item.attributedText.mutableCopy() as! NSMutableAttributedString
            var attributes: [NSAttributedStringKey: Any] = [:]
            
            var size: CGSize = CGSize(width: iconsColumnWidth, height: iconsColumnWidth)
            if let attributedImageItem = item as? FUIAttributedImage, let attrSize = attributedImageItem.size {
                size = attrSize
            }
            
            // resize attachments to the correct bounds
            if item.attributedText.containsAttachments(in: NSMakeRange(0, attributedText.length)) {
                item.attributedText.enumerateAttribute(.attachment, in: NSMakeRange(0, item.attributedText.length)) {
                    value, r, stop in
                    
                    if let value = value as? NSTextAttachment {
                        value.bounds = size.toRect()
                        attributedText.replaceCharacters(in: r, with: NSAttributedString(attachment: value))
                    }
                }
            }
            
            if let _ = item as? String {
                
                attributes.updateValue(UIFont.preferredFont(forTextStyle: .headline), forKey: .font)
                attributes.updateValue(UIColor.preferredFioriColor(forStyle: .primary3), forKey: .foregroundColor)
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacingBefore = index > 0 ? 4 : 0
            
            attributes[.paragraphStyle] = paragraphStyle
            
            
            if index < iconImages.count - 1 {
                attributedText.append(NSAttributedString(string: "\r"))
            }
            attributedText.addAttributes(attributes, range: NSMakeRange(0, attributedText.length))
            iconStrings.append(attributedText)
        }

        
        iconsStorage.setAttributedString(iconStrings)
        self.setNeedsUpdateConstraints()
        self.setNeedsDisplay()
    }
    
}
