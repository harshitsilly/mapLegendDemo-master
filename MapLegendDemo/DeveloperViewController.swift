//
//  ViewController.swift
//  MapTaskBar
//
//  Created by Takahashi, Alex on 7/5/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
}

class DeveloperViewController: UIViewController {

    var mapSpec: FUIMapViewSpec = FUIMapViewSpec()
    var toolbarSpec: FUIMapToolbarSpec = FUIMapToolbarSpec()
    var toolbar: FUIMapToolbar!
    var legendVC: MapLegendViewController? = nil
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    // Experimental
    var heightSpec = FUIDragHeightSpec()
    var dragView = FUIDragContainer()
    var dimOverLayCoord: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        setUpToolbar()
        setUpMap()
        experimental()
        if isPhone() {
            addDragView()
        }
    }
    
    @objc func handleRotation() {
//        if let dragViewWithTag = self.view.viewWithTag(1) {
//            dragViewWithTag.removeFromSuperview()
//        }
//        loadDragView()
    }
    
    func loadDragView() {
        let frame = self.view.frame
        dragView.frame = CGRect(x: 0, y: frame.height - heightSpec.minSearchHeight, width: frame.width, height: frame.height)
//        dragView.tag = 1
        self.view.addSubview(dragView)
//        dragView.setup(self)
    }
    
    func addDragView() {
        dragView = Bundle.main.loadNibNamed("DragView", owner: self, options: nil)?.last as! FUIDragContainer
        loadDragView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func setUpToolbar() {
//        toolbar = FUIMapToolbar()
//        toolbar.setup(withController: self)
//        toolbar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(toolbar)
//        toolbar.topAnchor.constraint(equalTo: view.topAnchor, constant: toolbarSpec.mapToolbarTopPadding).isActive = true
//        toolbar.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -toolbarSpec.mapToolbarRightPadding - 48).isActive = true
    }
}

// MARK: - SLIDEIN SETUP
extension DeveloperViewController: UIViewControllerTransitioningDelegate {
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

// MARK: - POPOVER SETUP
extension DeveloperViewController: UIPopoverPresentationControllerDelegate {
    func setupPopoverAttributes(onPopover popover: UIPopoverPresentationController, withSender sender: UIView) {
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        popover.permittedArrowDirections = .right
    }
}

// MARK: - MAP SETUP
extension DeveloperViewController: MKMapViewDelegate {
    
    func setUpMap() {
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
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - DIM Map
    
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
        
         let view = FUIMarkerAnnotationView(annotation: annotation, reuseIdentifier: "cell")
        if let img = mapSpec.mapAnnotationImage {
            view.glyphImage = img
            //view.markerTintColor = UIColor(hexString: "#6B4EA0")
            view.priorityIcon = UIImage(named:"notification_16px")!
            
        }
        if let txt = mapSpec.mapAnnotationGlyph {
            view.glyphText = txt
            //view.markerTintColor = UIColor(hexString: "#6B4EA0")
            view.priorityIcon = UIImage(named:"notification_16px")!
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation, !annotation.isEqual(selectedAnnotation) {
                let markerView = view as! FUIMarkerAnnotationView
                markerView.glyphImage = mapSpec.mapAnnotationImageSelected
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKAnnotation, annotation.isEqual(selectedAnnotation) {
                let markerView = view as! FUIMarkerAnnotationView
                markerView.glyphImage = mapSpec.mapAnnotationImage
            }
        }
    }
    
    private func compareCoord(coord1 coordA: CLLocationCoordinate2D, coord2 coordB: CLLocationCoordinate2D) -> Bool {
        return coordA.latitude == coordB.latitude && coordA.longitude == coordB.longitude
    }
}
// MARK: - Experimental
extension DeveloperViewController {
    func experimental() {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(launchDetailView), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func launchDetailView() {
        dragView = Bundle.main.loadNibNamed("DragView", owner: self, options: nil)?.last as! FUIDragContainer
        let frame = self.view.frame
        dragView.frame = CGRect(x: 0, y: frame.height - heightSpec.minSearchHeight, width: frame.width, height: frame.height)
        self.view.addSubview(dragView)
        dragView.setupViewContent(childController: UIViewController())
    }
}


