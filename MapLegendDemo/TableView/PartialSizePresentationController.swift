//
//  PartialSizePresentationController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/14/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class PartialSizePresentationController: UIPresentationController {
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    let screenSize = UIScreen.main.bounds.size
    private var direction: PresentationDirection

    override init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?) {
        self.direction = .left
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }
    
    private func setPresentedViewFrame(height preferredHeight: CGFloat, isPortrait portraitBool: Bool) {
        let yCoord = portraitBool ? screenSize.height - preferredHeight : 0
        let width = portraitBool ? screenSize.width : spec.mapLegendLandscapeTableWidth
        self.presentedView?.frame = CGRect(x: 0, y: yCoord, width: width, height: preferredHeight)
    }
    
    override func containerViewWillLayoutSubviews() {
        if presentingViewController is FUIMapView {
            let mapVC = presentingViewController as! FUIMapView
            if presentedViewController is MapLegendViewController {
                let mapLegendVC = presentedViewController as! MapLegendViewController
                let minHeight = spec.mapLegendMinTableHeight
                let maxHeight = spec.mapLegendMaxTableHeight
                let preferredheight = mapLegendVC.preferredContentSize.height
                if (preferredheight > minHeight && preferredheight < maxHeight) {
                    setPresentedViewFrame(height: preferredheight, isPortrait: isPortrait())
                } else {
                    (preferredheight <= minHeight) ? setPresentedViewFrame(height: minHeight, isPortrait: isPortrait()) : setPresentedViewFrame(height: maxHeight, isPortrait: isPortrait())
                }
            }
        }
    }
}
