//
//  GlyphImage.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 7/24/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit


protocol GlyphImage {
    var glyphText: String? { get }
    var glyphImage: UIImage? { get }
    var attributedText: NSAttributedString! { get }
}

extension UIImage: GlyphImage {
    
    var attributedText: NSAttributedString! {
        let iconString = NSMutableAttributedString(string: "\0")
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = self
        textAttachment.bounds = CGRect(origin: .zero, size: self.size)
        
        let textAttachmentString = NSAttributedString(attachment: textAttachment)
        iconString.append(textAttachmentString)
        iconString.addAttribute(.fuiGlyphImage, value: 1, range: NSMakeRange(0, iconString.length))
        return iconString
    }
    
    var glyphText: String? {
            return nil
    }
    
    var glyphImage: UIImage? {
       return self
    }
}

extension String: GlyphImage {
    var glyphText: String? {
        return self
    }
    
    var attributedText: NSAttributedString! {
        let attributedString = NSAttributedString(string: self, attributes: [.fuiGlyphString: 1])
        return attributedString
    }
}

class FUIAttributedImage: GlyphImage {
    
    var glyphImage: UIImage? {
        let size = self.size ?? self.image.size
        let image = isCircular ? self.image.circularImage(size: size) : self.image
        return image
    }
    
    var attributedText: NSAttributedString! {
        let attributedString: NSMutableAttributedString = glyphImage!.attributedText.mutableCopy() as! NSMutableAttributedString
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    var size: CGSize?
    var tintColor: UIColor? = nil
    var isCircular: Bool = false
    
    let image: UIImage!
    
    private var _attributes: [NSAttributedStringKey: Any] = [:]
    
    var attributes: [NSAttributedStringKey: Any] {
        get {
            if let tintColor = tintColor {
                _attributes.updateValue(tintColor, forKey: .foregroundColor)
            }
            return _attributes
        }
        set {
            _attributes = newValue
        }
    }
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(image: UIImage, attributes: [NSAttributedStringKey: Any]) {
        self.image = image
        self._attributes = attributes
    }
    
}


extension GlyphImage {
    var glyphText: String? {
        return nil
    }
    var glyphImage: UIImage? {
        return nil
    }
    
}

extension UIImage {
    
    func circularImage(size: CGSize?) -> UIImage {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context.setBlendMode(.copy)
        context.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
}

/*
class CircledGlyphImage: GlyphImage {
    var glyphText: String?
    
    var glyphImage: UIImage?
    
    var _attributedText: NSMutableAttributedString?
    var attributedText: NSAttributedString! {
        set {
            _attributedText = newValue.mutableCopy() as! NSMutableAttributedString
        }
        get {
            guard _attributedText == nil else {
                _attributedText?.addAttribute(NSAttributedStringKey(rawValue: "com.sap.sdk.glyph.string.circled"), value: 1, range: NSMakeRange(0, _attributedText!.length))
                return _attributedText
            }
            guard glyphText == nil else {
                return NSAttributedString(string: glyphText!, attributes: [NSAttributedStringKey(rawValue: "com.sap.sdk.glyph.string.circled"): 1])
            }
            return NSAttributedString(string: "")
        }
    }
}
*/

