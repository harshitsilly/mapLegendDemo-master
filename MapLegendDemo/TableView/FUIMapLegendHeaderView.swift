//
//  FUIMapLegendHeaderView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/10/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//
import UIKit

class FUIMapLegendHeaderView: UIView {
    
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    var cancelButton = UIButton()
    var view = UIView()
    
    init(withFrame frame: CGRect, withHeaderTitle title: String, withTableWidth tableWidth: CGFloat) {
        super.init(frame: frame)
        initialize(withFrame: frame, withHeaderTitle: title, withTableWidth: tableWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize(withFrame frame: CGRect, withHeaderTitle title: String, withTableWidth tableWidth: CGFloat) {
        var totalHeight: CGFloat = 0
        let vertPadding: CGFloat = 12
        let horizPadding: CGFloat = 8
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        view.accessibilityIdentifier = "$HeaderContainerView"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Header Text
        let mapLegendTextView = UITextView(frame: CGRect(x: 0, y: vertPadding, width: tableWidth, height: 0))
        mapLegendTextView.accessibilityIdentifier = "$HeaderTextView"
        let attrString = NSMutableAttributedString(string: title,
                                                   attributes: spec.mapLegendHeaderDefaultStrAttributes)
        mapLegendTextView.attributedText = attrString
        mapLegendTextView.textAlignment = .center
        mapLegendTextView.isEditable = false
        mapLegendTextView.isScrollEnabled = false
        mapLegendTextView.showsHorizontalScrollIndicator = false
        mapLegendTextView.showsVerticalScrollIndicator = false
        mapLegendTextView.textContainer.maximumNumberOfLines = 0
        mapLegendTextView.sizeToFit()
        
        mapLegendTextView.backgroundColor = UIColor.clear
        let textViewHeight = mapLegendTextView.frame.height
        totalHeight += textViewHeight + vertPadding + vertPadding
        view.addSubview(mapLegendTextView)
        
        // CancelButton
        if isPhone() {
            let origin = CGPoint(x: tableWidth - horizPadding - spec.mapLegendCancelButtonWidth, y: mapLegendTextView.center.y)
            let size = CGSize(width: spec.mapLegendCancelButtonWidth, height: spec.mapLegendCancelButtonHeight)
            let cancelRect = CGRect(origin: origin, size: size)
            cancelButton = UIButton(frame: cancelRect)
            cancelButton.accessibilityIdentifier = "$CancelButton"
            cancelButton.setBackgroundImage(UIImage(named: "clear_20px"), for: .normal)
            cancelButton.addTarget(self, action: #selector(MapLegendViewController.didPressCancelButton(_:)), for: .touchUpInside)
            view.addSubview(cancelButton)
            
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.centerYAnchor.constraint(equalTo: mapLegendTextView.centerYAnchor).isActive = true
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: spec.mapLegendCancelButtonHeight).isActive = true
            cancelButton.widthAnchor.constraint(equalToConstant: spec.mapLegendCancelButtonWidth).isActive = true
            cancelButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            cancelButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
        }

        // Divider View
        let divider = UIView(frame: CGRect(x: 0, y: 0, width: tableWidth, height: 1))
        divider.accessibilityIdentifier = "$DividerView"
        divider.backgroundColor = UIColor.lightGray
        totalHeight += divider.frame.height
        view.addSubview(divider)
        
        mapLegendTextView.translatesAutoresizingMaskIntoConstraints = false
        mapLegendTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: vertPadding).isActive = true
        mapLegendTextView.heightAnchor.constraint(equalToConstant: textViewHeight).isActive = true
        mapLegendTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizPadding).isActive = true
        if isPhone() {
            let headerText = mapLegendTextView.text as NSString
            let headerSize = headerText.size(withAttributes: spec.mapLegendHeaderDefaultStrAttributes )
            if (mapLegendTextView.frame.size.width > headerSize.width) {
                mapLegendTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
            } else {
                mapLegendTextView.trailingAnchor.constraint(greaterThanOrEqualTo: cancelButton.leadingAnchor, constant: -horizPadding).isActive = true
            }
        } else {
            mapLegendTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        }
        
        mapLegendTextView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        mapLegendTextView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
        
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: mapLegendTextView.bottomAnchor, constant: vertPadding).isActive = true
        divider.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        divider.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998), for: .horizontal)
        divider.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 998), for: .vertical)
        
        view.frame = CGRect(x: 0, y: 0, width: frame.width, height: totalHeight)
        self.view = view
    }
}
