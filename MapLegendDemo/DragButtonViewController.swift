//
//  DragButtonViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/17/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class DragButtonViewController: UIViewController {
    
    var spec: FUIMapToolbarSpec = FUIMapToolbarSpec()
    var toolbar: FUIMapToolbar!
    var stackCenter = CGPoint.zero
     
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar = FUIMapToolbar()
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(panButton(pan:)))
//        toolbar.addGestureRecognizer(pan)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: spec.mapToolbarTopPadding).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -spec.mapToolbarRightPadding).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func panButton(pan: UIPanGestureRecognizer) {
        switch (pan.state) {
            case .began:
                stackCenter = toolbar.center
            case .failed:
                toolbar.center = stackCenter
            case .cancelled:
                toolbar.center = stackCenter
            default:
                placeStack(pan: pan, view: view)
        }
    }
    
    func placeStack(pan givenPan: UIGestureRecognizer, view givenView: UIView) {
        let location = givenPan.location(in: givenView) // get pan location
        toolbar.center = location // set button to where finger is
    }
}
