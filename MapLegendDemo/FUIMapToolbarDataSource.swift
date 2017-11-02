//
//  FUIMapToolbarDataSource.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/18/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class FUIMapToolbarDataSource {
    var data: [FUIMapToolbarButton]? = nil
    
    init() {
        createVars()
    }
    
    func createVars() {
        // DataSource Components
        let legendBtn = FUIMapToolbarMapLegendButton(controller: nil, onImage: UIImage(named: "Legend_28px")!, offImage: UIImage(named: "Legend_28px")!, action: presentMapLegendClosure)
        let locationBtn = FUIMapToolbarUserLocationButton(onImage: UIImage(named: "location-on_24px")!, offImage: UIImage(named: "location-off_24px")!, action: centerUserLocationClosure)
        let clearAllBtn = FUIMapToolbarDimMapButton(controller: nil, onImage: UIImage(named: "clear all-on_28px")!, offImage: UIImage(named: "clear all-off_28px")!, action: dimMapViewClosure)
        let zoomExtentsBtn = FUIMapToolbarButton(onImage: UIImage(named: "Zoom Extent_28px")!, offImage: UIImage(named: "Zoom Extent_28px")!)
        let settingsBtn = FUIMapToolbarSettingsButton(onImage: UIImage(named: "icons8-Info-24")!, offImage: UIImage(named: "icons8-Info Filled-24")!, action: launchSettings)
        self.data = [settingsBtn, locationBtn, clearAllBtn, legendBtn, zoomExtentsBtn]
    }
    
    // Closures
    let presentMapLegendClosure: (FUIMapView, UIButton) -> Void =  { (vc, btn) in
        let storyboard : UIStoryboard = UIStoryboard(name: "MapLegendViewController", bundle: nil)
        vc.legendVC = (storyboard.instantiateViewController(withIdentifier: "storyBoard") as! MapLegendViewController)
        if isPhone() {
            vc.legendVC?.modalPresentationStyle = UIModalPresentationStyle.custom
            vc.legendVC?.transitioningDelegate = vc
            vc.legendVC?.view.layer.cornerRadius = 10;
            vc.legendVC?.view.layer.masksToBounds = true;
            vc.present(vc.legendVC!, animated: true, completion: nil)
        } else {
            vc.legendVC!.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.legendVC!.popoverPresentationController!
            popover.delegate = vc
            let popoverController = vc.legendVC!.popoverPresentationController
            vc.setupPopoverAttributes(onPopover: popoverController!, withSender: btn)
            vc.present(vc.legendVC!, animated: true, completion: nil)
        }
    }
    
    // Closures
    let presentSubview: (FUIMapView, UIButton) -> Void =  { (vc, btn) in
        let storyboard : UIStoryboard = UIStoryboard(name: "MapLegendViewController", bundle: nil)
//        vc.loadViewIfNeeded()
        vc.legendVC = (storyboard.instantiateViewController(withIdentifier: "storyBoard") as! MapLegendViewController)
        if isPhone() {
            vc.view.addSubview(vc.legendVC!.view)
//
//            let minHeight = 103
//            let maxHeight = 259
//            let preferredheight = mapLegendVC.preferredContentSize.height
//            if (preferredheight > minHeight && preferredheight < maxHeight) {
//                setPresentedViewFrame(height: preferredheight, isPortrait: isPortrait())
//            } else {
//                (preferredheight <= minHeight) ? setPresentedViewFrame(height: minHeight, isPortrait: isPortrait()) : setPresentedViewFrame(height: maxHeight, isPortrait: isPortrait())
//            }
//            
//            vc.legendVC?.modalPresentationStyle = UIModalPresentationStyle.custom
//            vc.legendVC?.transitioningDelegate = vc
//            vc.legendVC?.view.layer.cornerRadius = 10;
//            vc.legendVC?.view.layer.masksToBounds = true;
//            vc.present(vc.legendVC!, animated: true, completion: nil)
        } else {
            vc.legendVC!.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover: UIPopoverPresentationController = vc.legendVC!.popoverPresentationController!
            popover.delegate = vc
            let popoverController = vc.legendVC!.popoverPresentationController
            vc.setupPopoverAttributes(onPopover: popoverController!, withSender: btn)
            vc.present(vc.legendVC!, animated: true, completion: nil)
        }
    }
    
    let centerUserLocationClosure: (MKMapView) -> Void =  { mapView in
        var userCoord = mapView.userLocation.coordinate        
        var mapRegion = MKCoordinateRegion()
        let mapRegionSpan = 0.0075
        mapRegion.center = userCoord
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        mapView.setRegion(mapRegion, animated: true)

    }
    
    let dimMapViewClosure: (MKMapView, FUIMapToolbarButton) -> Void = {mapView, btn in
        let dimOverlay : DimOverlay = DimOverlay(mapView: mapView)
        if !btn.isOn {
            mapView.add(dimOverlay)
        } else {
            let overlays = mapView.overlays
            mapView.removeOverlays(overlays)
        }
        btn.toggleButtonState(btn)
        btn.toggleButtonState(btn) // /I HAVE NO IDEA WHY I NEED TO TOGGLE TWICE
    }
    
    let launchSettings: (FUIMapView) -> Void = {mapVC in
        let storyboard = UIStoryboard(name: "MapSettingsViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "mapNavigation")
        if !isPhone() {
            controller.modalPresentationStyle = .formSheet
        }
        mapVC.present(controller, animated: true, completion: nil)
    }
}

