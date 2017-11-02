//
//  FUISearchBar.swift
//  SAPFiori
//
//  Copyright © 2016 - 2017 SAP SE or an SAP affiliate company. All rights reserved.
//
//  No part of this publication may be reproduced or transmitted in any form or for any purpose
//  without the express permission of SAP SE. The information contained herein may be changed
//  without prior notice.
//

import UIKit
//import AVFoundation
//import SAPCommon

/**
 Fiori style UISearchBar.
 
 Developer can add a `FUIBarcodeScanner` to this `FUISearchBar` by setting the
 `isBarcodeScannerEnabled` property of the `FUISearchBar` to true. A barcode scanner
 icon will be displayed at the bookmark icon location of the search bar.
 
 A barcode scanner view will be displayed when the barcode scanner icon is tapped.
 
 Please refer to `FUISearchController` about how to use this `FUISearchBar`.
 */
public class FUISearchBar: UISearchBar {
    
    var searchSpec = FUISearchBarCornerSpec()
    
    internal weak var backingDelegate: UISearchBarDelegate? {
        didSet {
            super.delegate = backingDelegate
        }
    }
    
    // internal:  referenced from FUISearchController
    weak var developerDelegate: UISearchBarDelegate?
    
    //// :nodoc:
    override public weak var delegate: UISearchBarDelegate? {
        get {
            return backingDelegate ??  developerDelegate ?? super.delegate
        }
        
        set {
            developerDelegate = newValue
            if backingDelegate == nil {
                super.delegate = newValue
            }
        }
    }
    
    /**
     The customized placeholder text.
     */
    public var placeholderText: String? = nil {
        didSet {
            self.setupSearchPlaceholder()
        }
    }
    
    /**
     The placehoder text font. Default is Fiori style subheadline.
     */
    public var placeholderTextFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline)
    
    /**
     The placeholderTextColor. Default is #8E8E8E.
     */
    public var placeholderTextColor: UIColor = UIColor.black
    
    
    /// :nodoc:
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    /// :nodoc:
    override public init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    
    /// Convenience initializer for internal use.
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func config() {
//        self.barTintColor = UIColor.clear
        // BCP: 1780204963, LocalSearch-Remove Lines
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor //nil//UIColor.green.cgColor
    }
    
    /// :nodoc:
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupSearchPlaceholder()
    }
    
    private func setupSearchPlaceholder() {
        var searchText = placeholderText
        if searchText == nil {
            searchText = placeholder
        }
        if searchText != nil {
            let textField = getSearchTextField()
            textField.attributedPlaceholder = NSAttributedString(string: searchText!, attributes: [NSAttributedStringKey.foregroundColor: placeholderTextColor, NSAttributedStringKey.font: placeholderTextFont])
        }
    }
    
    func getSearchTextField() -> UITextField {
        // Uncomment the next line to see the search bar subviews.
        // print(subviews[0].subviews)
        
        var textField: UITextField?
        let searchBarView = subviews[0]
        
        for view in searchBarView.subviews {
            if view is UITextField {
                textField = view as? UITextField
                break
            }
        }
        return textField!
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        var width = isPhone() ? UIScreen.main.bounds.width : searchSpec.searchBarCornerWidth
        self.frame = CGRect(x: 0, y: 0, width: width, height: 68)
    }
}

