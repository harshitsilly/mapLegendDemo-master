//
//  FUIMapDragView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/27/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit
import QuartzCore
import MapKit

class FUIMapView: UIViewController, MKMapViewDelegate {
    var mapSpec: FUIMapViewSpec = FUIMapViewSpec()
    var toolbarSpec: FUIMapToolbarSpec = FUIMapToolbarSpec()
    var toolbar: FUIMapToolbar!
    var legendVC: MapLegendViewController? = nil
    var locationManager = CLLocationManager()
    
    var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func setupMapView() {
        mapView = MKMapView()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cell")
        mapView.showsUserLocation = true
        var mapRegion = MKCoordinateRegion()
        let mapRegionSpan = 0.0075
        mapRegion.center = mapSpec.mapLocationCoord
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan
        mapView.setRegion(mapRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapSpec.mapLocationCoord
        annotation.title = mapSpec.mapCoordTitle
        annotation.subtitle = mapSpec.mapCoordSubtitle
        mapView.addAnnotation(annotation)
        
        var berkeleyAnnotation = MKPointAnnotation()
        berkeleyAnnotation.coordinate = CLLocationCoordinate2DMake(37.8719, -122.2585)
        berkeleyAnnotation.title = "A Way Better School"
        berkeleyAnnotation.subtitle = "But Oski is super creepy"
        mapView.addAnnotation(annotation)
        mapView.addAnnotation(berkeleyAnnotation)
    }
    
    func setupToolbar() {
        toolbar = FUIMapToolbar()
        toolbar.setup(withController: self)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: toolbarSpec.mapToolbarTopPadding).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -toolbarSpec.mapToolbarRightPadding - 48).isActive = true
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is DimOverlay {
            return DimOverlayRenderer(overlay: overlay, dimAlpha: 0.3, color: .black)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if (compareCoord(coord1: annotation.coordinate, coord2: mapView.userLocation.coordinate)) {
            return nil
        }
        
        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "cell")
        if let img = mapSpec.mapAnnotationImage {
            view.glyphImage = mapSpec.mapAnnotationImage
        }
        if let txt = mapSpec.mapAnnotationGlyph {
            view.glyphText = mapSpec.mapAnnotationGlyph
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation, !annotation.isEqual(selectedAnnotation) {
                let markerView = view as! MKMarkerAnnotationView
                markerView.glyphImage = mapSpec.mapAnnotationImageSelected
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation, annotation.isEqual(selectedAnnotation) {
                let markerView = view as! MKMarkerAnnotationView
                markerView.glyphImage = mapSpec.mapAnnotationImage
            }
        }
    }
    
    private func compareCoord(coord1 coordA: CLLocationCoordinate2D, coord2 coordB: CLLocationCoordinate2D) -> Bool {
        return coordA.latitude == coordB.latitude && coordA.longitude == coordB.longitude
    }
}
extension FUIMapView: UIPopoverPresentationControllerDelegate {
    func setupPopoverAttributes(onPopover popover: UIPopoverPresentationController, withSender sender: UIView) {
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        popover.permittedArrowDirections = .right
    }
}

extension FUIMapView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PartialSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: modalPresentationDirection(), isPresentation: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return SlideInPresentationAnimator(direction: modalPresentationDirection(), isPresentation: false)
    }
}

class DevVC: FUIMapView {
    var heightSpec = FUIDragHeightSpec()
    var container: FUISearchContainerView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "$devVC"
        container = FUISearchContainerView(parentViewController: self)
        let source = DevProtocols(container: container!)
        container!.isSearchEnabled = true
        container!.searchResultsViewController!.dataSource = source
        container!.searchResultsViewController!.delegate = source
        container!.searchResultsViewController!.searchResultsUpdater = source
        container!.searchResultsViewController!.searchBarDelegate = source
        container!.childViewController = MapDetailTestingTableViewController()
        self.view.accessibilityIdentifier = "$UltimateContainer"
        
        toolbar = FUIMapToolbar()
        toolbar.setup(withController: self)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: toolbarSpec.mapToolbarTopPadding).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -toolbarSpec.mapToolbarRightPadding - 48).isActive = true
        
        setupPushPopButtons()
    }
    
    func setupPushPopButtons() {
        let rect = CGRect(origin: CGPoint(x: UIScreen.main.bounds.maxX - 116, y: UIScreen.main.bounds.maxY - 116 ), size: CGSize(width: 100, height: 100))
        let button = UIButton()
        self.view.addSubview(button)
        button.backgroundColor = .green
        button.setTitle("Push", for: .normal)
        button.addTarget(container!.cornerContainer, action: #selector(FUIResizableCornerView.pushDetailView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -216).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        let button2 = UIButton()
        self.view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button2.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button2.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -116).isActive = true
        button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button2.backgroundColor = .red
        button2.setTitle("Pop", for: .normal)
        button2.addTarget(container!.cornerContainer, action: #selector(FUIResizableCornerView.popDetailView), for: .touchUpInside)
    }
}

// Archived
extension DevVC {
    
    func addLineMarkers() {
        let topMidViewFrame = CGRect(x: 0, y: heightSpec.topMidY, width: UIScreen.main.bounds.width, height: 1)
        let topMidView = UIView(frame: topMidViewFrame)
        topMidView.backgroundColor = UIColor.red
        view.addSubview(topMidView)
        topMidView.accessibilityLabel = "$TopMidLine"
        topMidView.translatesAutoresizingMaskIntoConstraints = false
        topMidView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightSpec.topMidY).isActive = true
        topMidView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topMidView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topMidView.heightAnchor.constraint(equalToConstant: topMidViewFrame.height).isActive = true
        
        let botMidYViewFrame = CGRect(x: 0, y: heightSpec.bottomMidY, width: UIScreen.main.bounds.width, height: 1)
        let botMidView = UIView(frame: botMidYViewFrame)
        botMidView.backgroundColor = UIColor.red
        view.addSubview(botMidView)
        botMidView.accessibilityLabel = "$BotMidLine"
        botMidView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightSpec.bottomMidY).isActive = true
        botMidView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        botMidView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        botMidView.heightAnchor.constraint(equalToConstant: botMidYViewFrame.height).isActive = true
        
        let minStateFrame = CGRect(x: 0, y: heightSpec.minStateY, width: UIScreen.main.bounds.width, height: 1)
        let minStateView = UIView(frame: minStateFrame)
        minStateView.backgroundColor = UIColor.yellow
        minStateView.accessibilityLabel = "$MinStateLine"
        view.addSubview(minStateView)
        minStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightSpec.bottomMidY).isActive = true
        minStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        minStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        minStateView.heightAnchor.constraint(equalToConstant: minStateFrame.height).isActive = true
        
        let partialStateFrame = CGRect(x: 0, y: heightSpec.partialStateY, width: UIScreen.main.bounds.width, height: 1)
        let partialStateView = UIView(frame: partialStateFrame)
        partialStateView.backgroundColor = UIColor.yellow
        view.addSubview(partialStateView)
        partialStateView.accessibilityLabel = "$PartialStateMidLine"
        partialStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightSpec.partialStateY).isActive = true
        partialStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        partialStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        partialStateView.heightAnchor.constraint(equalToConstant: partialStateFrame.height).isActive = true
    }
}

