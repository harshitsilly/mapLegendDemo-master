//
//  FUIMapToolbarButton.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/18/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

protocol FUIMapToolbarButtonClosureHandling {
    associatedtype ClosureType
    var didSelectHandler: ClosureType? { get set }
    func addTarget()
    func didTap()
}

protocol FUIMapToolbarButtonHandling {
    var spec: FUIMapToolbarSpec { get set }
    var isOn: Bool { get set }
    var onImage: UIImage! { get set }
    var offImage: UIImage! { get set }
    func setup(_ btn: FUIMapToolbarButton, withSpec spec: FUIMapToolbarSpec)
    func setButtonImage(_ btn: FUIMapToolbarButton)
    func toggleButtonState(_ btn: FUIMapToolbarButton)
    func getImage(_ btn: FUIMapToolbarButton) -> UIImage
    func getState(_ btn: FUIMapToolbarButton) -> Bool
}

extension FUIMapToolbarButtonHandling {
    func setup(_ btn: FUIMapToolbarButton, withSpec spec: FUIMapToolbarSpec) {
        btn.setImage(getImage(btn), for: .normal)
        btn.heightAnchor.constraint(equalToConstant: spec.mapToolbarButtonHeight).isActive = true
        btn.widthAnchor.constraint(equalToConstant: spec.mapToolbarButtonWidth).isActive = true
        btn.backgroundColor = UIColor.clear
        btn.layer.backgroundColor = UIColor.clear.cgColor
        btn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn.translatesAutoresizingMaskIntoConstraints = false
    }

    func setButtonImage(_ btn: FUIMapToolbarButton) {
        toggleButtonState(btn)
        btn.setImage(getImage(btn), for: .normal)
    }
    
    func toggleButtonState(_ btn: FUIMapToolbarButton) {
        btn.isOn = !btn.isOn
    }
    
    func getImage(_ btn: FUIMapToolbarButton) -> UIImage {
        return btn.isOn ? btn.onImage : btn.offImage
    }
    
    func getState(_ btn: FUIMapToolbarButton) -> Bool {
        return btn.isOn
    }

}

class FUIMapToolbarButton: UIButton, FUIMapToolbarButtonHandling {
    var spec: FUIMapToolbarSpec = FUIMapToolbarSpec()
    var controller: FUIMapView? = nil
    var isOn: Bool = false
    var onImage: UIImage!
    var offImage: UIImage!
    
    // Make onImage optionals,  if you dont provide image just white square
    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage) {
        super.init(frame: CGRect.zero)
        self.controller = givenController
        self.onImage = givenOnImage
        self.offImage = givenOffImage
        setup(self, withSpec: spec)
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage) {
        self.onImage = givenOnImage
        self.offImage = givenOffImage
        super.init(frame: CGRect.zero)
        setup(self, withSpec: spec)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class FUIMapToolbarMapLegendButton: FUIMapToolbarButton, FUIMapToolbarButtonClosureHandling {
    
    var didSelectHandler: ((FUIMapView, UIButton) -> Void)? = nil
    typealias ClosureType = ((FUIMapView, UIButton) -> Void)
    
    func addTarget() {
        self.addTarget(self, action: #selector(didTap), for: .primaryActionTriggered)
    }

    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView, UIButton) -> Void)) {
        super.init(controller: givenController, onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView, UIButton) -> Void)) {
        super.init(onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func didTap() {
        if let didSelectHandler = self.didSelectHandler {
            NotificationCenter.default.addObserver(self, selector: "rotationHandlerDismiss", name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            didSelectHandler(controller!, self)
            setButtonImage(self)
        }
    }
    
    @objc func rotationHandlerDismiss(){
        let curState = isPortrait()
        controller!.legendVC!.dismiss(animated: true, completion: {
            print("I dismissed!")
            self.didTap()
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("rotationHandlerDismiss"), object: nil)
    }
}

class FUIMapToolbarUserLocationButton: FUIMapToolbarButton, FUIMapToolbarButtonClosureHandling {
    
    var didSelectHandler: ((MKMapView) -> Void)? = nil
    typealias ClosureType = ((MKMapView) -> Void)
    
    func addTarget() {
        self.addTarget(self, action: #selector(didTap), for: .primaryActionTriggered)
    }
    
    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((MKMapView) -> Void)) {
        super.init(controller: givenController, onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((MKMapView) -> Void)) {
        super.init(onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func didTap() {
        print("I tapped this")
        if let didSelectHandler = self.didSelectHandler {
            didSelectHandler(controller!.mapView)
            setButtonImage(self)
        }
    }
}

class FUIMapToolbarDimMapButton: FUIMapToolbarButton, FUIMapToolbarButtonClosureHandling {
    
    var didSelectHandler: ((MKMapView, FUIMapToolbarButton) -> Void)? = nil
    typealias ClosureType = ((MKMapView, FUIMapToolbarButton) -> Void)
    
    func addTarget() {
        self.addTarget(self, action: #selector(didTap), for: .primaryActionTriggered)
    }
    
    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((MKMapView, FUIMapToolbarButton) -> Void)) {
        super.init(controller: givenController, onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((MKMapView, FUIMapToolbarButton) -> Void)) {
        super.init(onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func didTap() {
        print("I tapped this")
        if let didSelectHandler = self.didSelectHandler {
            didSelectHandler(controller!.mapView, self)
            setButtonImage(self)
        }
    }
}

class FUIMapToolbarSettingsButton: FUIMapToolbarButton, FUIMapToolbarButtonClosureHandling {
    
    var didSelectHandler: ((FUIMapView) -> Void)? = nil
    typealias ClosureType = ((FUIMapView) -> Void)
    
    func addTarget() {
        self.addTarget(self, action: #selector(didTap), for: .primaryActionTriggered)
    }
    
    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView) -> Void)) {
        super.init(controller: givenController, onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView) -> Void)) {
        super.init(onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func didTap() {
        print("I tapped this")
        if let didSelectHandler = self.didSelectHandler {
            didSelectHandler(controller!)
            setButtonImage(self)
        }
    }
}

class FUIMapToolbarDetailViewButton: FUIMapToolbarButton, FUIMapToolbarButtonClosureHandling {
    
    var didSelectHandler: ((FUIMapView) -> Void)? = nil
    typealias ClosureType = ((FUIMapView) -> Void)
    
    func addTarget() {
        self.addTarget(self, action: #selector(didTap), for: .primaryActionTriggered)
    }
    
    init(controller givenController: FUIMapView?, onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView) -> Void)) {
        super.init(controller: givenController, onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    init(onImage givenOnImage: UIImage, offImage givenOffImage: UIImage, action givenClosure: @escaping ((FUIMapView) -> Void)) {
        super.init(onImage: givenOnImage, offImage: givenOffImage)
        self.didSelectHandler = givenClosure
        addTarget()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc func didTap() {
        print("I tapped this")
        if let didSelectHandler = self.didSelectHandler {
            didSelectHandler(controller!)
            setButtonImage(self)
        }
    }
}
