//
//  FUIMapLegendIcon.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/13/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapLegendIcon {
    
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    
    private var backgroundColor: UIColor
    private var iconImage: UIImage? = nil
    private var iconText: String? = nil
    
    init(image givenImage: UIImage, color givenColor: UIColor) {
        self.backgroundColor = givenColor
        self.iconImage = givenImage
    }
    
    init(text givenText: String, color givenColor: UIColor) {
        self.backgroundColor = givenColor
        self.iconText = givenText
    }
    
    init(image givenImage: UIImage, text givenText: String, color givenColor: UIColor) {
        self.backgroundColor = givenColor
        self.iconImage = givenImage
        self.iconText = givenText
    }
    
    private func createAttributedStringImage(ofImage image: UIImage) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "\0")
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSMakeRange(0, 1), with: attrStringWithImage)
        return attributedString
    }
    
    private func createAttributedString(_ str: String) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let strAttributes = [NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.font: spec.mapLegendIconFont, NSAttributedStringKey.foregroundColor: spec.mapLegendIconTextColor] as [NSAttributedStringKey : Any]
        let attributedString = NSAttributedString(string: str as String, attributes: strAttributes)
        return attributedString
    }
    
    // The text is always prioritized over image (just like glphy map image)
    func getString() -> NSAttributedString {
        if self.iconText != nil {
            return createAttributedString(self.iconText!)
        } else {
            return createAttributedStringImage(ofImage: self.iconImage!)
        }
    }
}
