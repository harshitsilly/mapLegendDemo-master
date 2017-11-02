//
//  DragButtonStack.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/18/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapToolbar: UIView {

    var spec: FUIMapToolbarSpec = FUIMapToolbarSpec()
    var dataSource = FUIMapToolbarDataSource()
    var controller: FUIMapView!

    private var toolbarStackView: UIStackView = UIStackView()
    private var isDarkMode: Bool = false
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    init(frame: CGRect, controller: FUIMapView) {
        super.init(frame: frame)
        setup(withController: controller)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(withController controller: FUIMapView) {
        self.controller = controller
        backgroundView.backgroundColor = isDarkMode ? spec.mapToolbarBackgroundColorDark : spec.mapToolbarBackgroundColorLight
        pinBackground(backgroundView, to: toolbarStackView)
        
        for item in dataSource.data! {
            item.controller = self.controller
            toolbarStackView.addArrangedSubview(item)
        }
        
        toolbarStackView.axis = UILayoutConstraintAxis.vertical
//        toolbarStackView.distribution = UIStackViewDistribution.equalSpacing
        toolbarStackView.spacing = spec.mapToolbarStackSpacing

        toolbarStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(toolbarStackView)
        toolbarStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        toolbarStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        toolbarStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        toolbarStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
    }
}
public extension UIView {
    public func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}
