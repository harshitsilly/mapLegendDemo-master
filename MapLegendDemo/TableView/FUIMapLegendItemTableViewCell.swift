//
//  FUIMapLegendItemTableViewCell.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/6/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

let useImages = true

class FUIMapLegendItemTableViewCell: UITableViewCell {
    
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    open static var reuseIdentifier: String {
        return "\(String(describing: self))"
    }
    
    // Outlets
    var mapLegendItemTitleLabel: UILabel!
    var iconLineStackView: UIStackView!
    var iconTextView: UITextView!
    var lineView: FUIMapLegendLinePathView!
    
    var mapItem: FUIMapLegendItem? = nil {
        didSet {
            if let m = mapItem {
                manageTitleLabel(m)
                manageIconTextView(m)
                manageLineView(m)
                manageVerticalConstraints()
            }
        }
    }
    
    func manageIconTextView(_ m: FUIMapLegendItem) {
        if let attrStr = m.getString() {
            iconTextView.attributedText = attrStr
            centerTextView(attrStr)
            iconTextView.backgroundColor = m.getColor()
        }
        iconTextView.isHidden = (m.getString() == nil)
    }
    
    func manageTitleLabel(_ m: FUIMapLegendItem) {
        let mutableStr = NSMutableAttributedString(string: m.getTitle(), attributes: spec.mapLegendDefaultStrAttributes as! [NSAttributedStringKey : Any])
        mapLegendItemTitleLabel.attributedText = mutableStr
    }
    
    func manageLineView(_ m: FUIMapLegendItem) {
        if let shapeLayer = m.getLineLayer() {
            lineView.lineLayer = shapeLayer
        }
        lineView.isHidden = (m.getLineLayer() == nil)
    }
    
    func manageVerticalConstraints() {
        iconLineStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconLineStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12).isActive = true
        iconLineStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12).isActive = true
        mapLegendItemTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        mapLegendItemTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 12).isActive = true
        mapLegendItemTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12).isActive = true
    }
    
    func centerTextView(_ text: NSAttributedString) {
        let width = CGFloat.greatestFiniteMagnitude
        let rect = text.boundingRect(with: CGSize(width: width, height: 1000) , options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let textViewHeight = spec.mapLegendIconViewLength
        var top = (textViewHeight - rect.height * (iconTextView?.zoomScale)!) / 2.0
        top = top < 0.0 ? 0.0 : top
        iconTextView?.textContainerInset.top = top
        drawCircle(onView: iconTextView)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = UIColor.default
        iconLineStackView = {
            let stack = UIStackView()
            stack.backgroundColor = UIColor.clear
            stack.axis = UILayoutConstraintAxis.vertical
            stack.spacing = spec.mapLegendIconStackSpacing
            return stack
        }()
        iconLineStackView.accessibilityLabel = "$IconLineStack"
        contentView.addSubview(iconLineStackView)
        
        mapLegendItemTitleLabel = {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 2
            return label
        }()
        mapLegendItemTitleLabel.accessibilityLabel = "$MapLegendItemTitle"
        contentView.addSubview(mapLegendItemTitleLabel)
        
        iconTextView = {
            let txtView = UITextView()
            txtView.backgroundColor = mapItem?.getColor()
            txtView.isEditable = false
            txtView.textAlignment = .center
            txtView.isScrollEnabled = false
            txtView.showsVerticalScrollIndicator = false
            txtView.showsHorizontalScrollIndicator = false
            
            txtView.translatesAutoresizingMaskIntoConstraints = false
            txtView.heightAnchor.constraint(equalToConstant: spec.mapLegendIconViewLength).isActive = true
            txtView.widthAnchor.constraint(equalToConstant: spec.mapLegendIconViewLength).isActive = true
            txtView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
            return txtView
        }()
        iconTextView.accessibilityLabel = "$IconTextView"
        iconLineStackView.addArrangedSubview(iconTextView)
        
        lineView = {
            print("Line View")
            let view = FUIMapLegendLinePathView()
//            view.backgroundColor = UIColor.black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
            view.heightAnchor.constraint(equalToConstant: spec.mapLegendLineHeight).isActive = true
            view.widthAnchor.constraint(equalToConstant: spec.mapLegendLineWidth).isActive = true
            view.clipsToBounds = true
            view.layer.masksToBounds = true
//            view.contentMode = .redraw
            return view
        }()
        lineView.accessibilityLabel = "$LineView"
        iconLineStackView.addArrangedSubview(lineView!)

        // CONSTRAINTS
        iconLineStackView.translatesAutoresizingMaskIntoConstraints = false
        mapLegendItemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Manage Width Constraints
        iconLineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.layoutMargins.left).isActive = true
        iconLineStackView.widthAnchor.constraint(equalToConstant: spec.mapLegendIconViewLength).isActive = true
        mapLegendItemTitleLabel.leadingAnchor.constraint(equalTo: iconLineStackView.trailingAnchor, constant: spec.mapLegendIconRightPadding).isActive = true
        mapLegendItemTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -self.layoutMargins.right).isActive = true
        
        // Manage Height Constraints
        manageVerticalConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawCircle(onView view: UIView?) {
        guard view != nil else {
            return
        }
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: CGFloat(spec.mapLegendIconViewLength / 2) ,y: CGFloat(spec.mapLegendIconViewLength / 2)), radius: CGFloat(spec.mapLegendIconViewLength / 2), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.strokeColor = UIColor.clear.cgColor
        view?.layer.mask = shapeLayer
    }
}
