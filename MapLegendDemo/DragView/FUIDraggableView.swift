//
//  FUIDraggableView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 8/7/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit


func getScreenHeight() -> CGFloat{
    let screenSize = UIScreen.main.bounds.size
    return isPortrait() ? max(screenSize.height, screenSize.width) : min(screenSize.height, screenSize.width)
}

class FUIDragHeightSpec {
    var minSearchHeight: CGFloat { get {return 80}}
    var minDetailHeight: CGFloat { get {return 80}}
    var minStateY: CGFloat {get {
        let screenHeight = getScreenHeight()
        return screenHeight - minSearchHeight}
    }
    var partialStateY: CGFloat {get {return 410}}
    var partialStateHeight: CGFloat {get {
        let screenHeight = getScreenHeight()
        return screenHeight - partialStateY}
    }
    var bottomMidY: CGFloat {get {return minStateY - 10}}
    var topMidY: CGFloat {get {return topBoundaryY + 10}}
    var topBoundaryY: CGFloat {get {return isPortrait() ? 44 : 32}}
}

class FUIDragContainer: UIView, UICollisionBehaviorDelegate {
    
    var minimalHeight: CGFloat!
    var isSearchEnabled: Bool? = nil
    var searchResultsViewController: FUISearchResultsViewController? = nil
    // Spec
    var heightSpec = FUIDragHeightSpec()
    var dragSpec = SearchDragSpec()
    
    var animator:UIDynamicAnimator!
    var container:UICollisionBehavior!
    var snap:UISnapBehavior!
    var dynamicItem:UIDynamicItemBehavior!
    var gravity:UIGravityBehavior!
    var panGestureRecognizer:UIPanGestureRecognizer!
    
    var childVC: FUIMapDragContentViewController!
    var parentVC: UIViewController!
    var isKeyboardVisible = false
    var isMinimalState = true
    var isSearch = false
    
    // View Configuration
    func setupViewContent(childController child: UIViewController) {
        let dragContent = FUIMapDragContentViewController(dragContent: child)
        dragContent.setup()
        self.childVC = dragContent
        self.parentVC.view.addSubview(self)
        addContentView()
        self.isSearch = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addContentView() {
        
        childVC.view.layer.cornerRadius = 10
        childVC.view.backgroundColor = .white
        childVC.accessibilityLabel = "$DraggableViewVC"
        configSubview(withController: childVC)
    }
    
    func configSubview(withController controller: FUIMapDragContentViewController) {
        childVC = controller
        addSubview(controller.view)
        controller.didMove(toParentViewController: parentVC)
        parentVC.addChildViewController(childVC)
    }
    
    @objc func rotationHandler() {
        animator.removeAllBehaviors()
        container.removeAllBoundaries()
        dynamicItem.removeItem(self)
        NotificationCenter.default.removeObserver(self)
        didMoveToWindow()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        childVC.view.frame = self.bounds
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendDragToTop), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardIsShowing), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardIsNotShowing), name: .UIKeyboardWillHide, object: nil)
        
        self.accessibilityIdentifier = "$DragView"
        let bounds = self.window!.bounds
        var placementY = isMinimalState ? heightSpec.minStateY : heightSpec.topBoundaryY
        
        if placementY == heightSpec.topBoundaryY {
            placementY = getTopBoundary(maxAcceptableY: heightSpec.topBoundaryY)
        }
        self.frame = CGRect(x: 0, y: placementY, width: bounds.width, height: bounds.height)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(handlePan(pan:)))
        panGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(panGestureRecognizer)
        
        dynamicItem = UIDynamicItemBehavior(items: [self])
        dynamicItem.allowsRotation = false
        dynamicItem.elasticity = 0
        
        gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVector(dx: 0, dy: isMinimalState ? 1 : -1)
        
        container = UICollisionBehavior(items: [self])
        container.accessibilityLabel = "$BoundaryContainer"
        container.collisionDelegate = self
        configureContainer()
        
        animator = UIDynamicAnimator(referenceView: self.window!)
        animator.addBehavior(gravity)
        animator.addBehavior(self.dynamicItem)
        animator.addBehavior(container)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.rotationHandler), name: .UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotationHandler), name: Notification.Name("preferredContentDidChange"), object: nil)
        
    }
    
    // Draggable Interaction Configureation
    @objc func handlePan(pan: UIPanGestureRecognizer) {
        stopTVCScroll(childVC: childVC)
        removeMidBoundaries()
        guard !isKeyboardVisible else {
            return
        }
        let velocity = pan.velocity(in: self.superview).y
        var movement = self.frame
        movement.origin.x = 0
        movement.origin.y = movement.origin.y + (velocity * 0.05)
        
        if pan.state == .ended {
            panGestureEnded()
        } else if pan.state == .began {
            snapToTop()
        } else {
            if snap != nil {
                animator.removeBehavior(snap)
            }
            let snapPoint = CGPoint(x: movement.midX, y: movement.midY)
            snap = UISnapBehavior(item: self, snapTo: snapPoint)
            animator.addBehavior(snap)
        }
    }
    
    func didflick(withVelocity vel: CGPoint) {
        removeMidBoundaries()
        if vel.y < 0 {
            sendDragToTop()
        } else {
            snapToBottom()
        }
    }
    
    func panGestureEnded() {
        guard snap != nil else {
            return
        }
        
        animator.removeBehavior(snap)
        
        let velocity = self.dynamicItem.linearVelocity(for: self)
        
        if abs(Float(velocity.y)) > 250 {
            didflick(withVelocity: velocity)
        } else {
            if (self.superview?.bounds.size.height) != nil {
                if self.frame.origin.y > heightSpec.partialStateY {
                    dragBelowPartialState()
                } else {
                    dragAbovePartialState()
                }
            }
        }
    }
    
    func snapToBottom() {
        gravity.gravityDirection = CGVector(dx: 0, dy: 2.5)
    }
    
    func snapToTop() {
        gravity.gravityDirection = CGVector(dx: 0, dy: -2.5)
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        guard identifier as! String != "left" else {
            return
        }
        guard identifier as! String != "right" else {
            return
        }
        isMinimalState = identifier as! String == "minState"
    }
    
    func configureContainer() {
        removeContainerBoundaries()
        let screenSize = UIScreen.main.bounds.size
        let boundaryHeight = screenSize.height
        let boundaryWidth = screenSize.width
        
        var upperY = heightSpec.topBoundaryY
        upperY = getTopBoundary(maxAcceptableY: upperY)
//        if childVC.dragContent is MapDetailTestingTableViewController {
//            let vc = childVC.dragContent as! MapDetailTestingTableViewController
//            let dragContentY = getScreenHeight() - childVC.preferredContentSize.height//vc.tableView.contentSize.height -
//            upperY = (upperY > dragContentY) ? upperY : dragContentY
//        }
        
        let upperStartPoint = CGPoint(x: 0, y: upperY)
        let upperEndPoint = CGPoint(x: boundaryWidth, y: upperY)
        container.addBoundary(withIdentifier: "upper" as NSCopying, from: upperStartPoint, to: upperEndPoint)
        
        let leftStartPoint = CGPoint(x: 0, y: 0)
        let leftEndPoint = CGPoint(x: 0, y: boundaryHeight)
        container.addBoundary(withIdentifier: "left" as NSCopying, from: leftStartPoint, to: leftEndPoint)
        
        let rightStartPoint = CGPoint(x: boundaryWidth, y: 0)
        let rightEndPoint = CGPoint(x: boundaryWidth, y: boundaryHeight)
        container.addBoundary(withIdentifier: "right" as NSCopying, from: rightStartPoint, to: rightEndPoint)
        
        var bottomHeight: CGFloat = 0
        bottomHeight = isSearch ? heightSpec.minSearchHeight : 83
        addBottomBoundaries(withIdentifier: "minState", bottomHeight: bottomHeight)
    }
    
    func getTopBoundary(maxAcceptableY max: CGFloat) -> CGFloat{
        var positionY = max
        if childVC.dragContent is MapDetailTestingTableViewController {
            let vc = childVC.dragContent as! MapDetailTestingTableViewController
            let dragContentY = getScreenHeight() - childVC.preferredContentSize.height//vc.tableView.contentSize.height -
            positionY = (max > dragContentY) ? max : dragContentY
        }
        return positionY
    }
    
    func removeContainerBoundaries() {
        container.removeAllBoundaries()
    }
    
    func addBottomBoundaries(withIdentifier identifier: String, bottomHeight height: CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        let boundaryWidth = screenSize.width
        let boundaryHeight = screenSize.height
        let lowerStartPoint = CGPoint(x: 0, y: boundaryHeight * 2 - height)
        let lowerEndPoint = CGPoint(x: boundaryWidth, y: boundaryHeight * 2 - height)
        container.addBoundary(withIdentifier: identifier as NSCopying, from: lowerStartPoint, to: lowerEndPoint)
    }
    
    func addTopBoundaries(withIdentifier identifier: String, topHeight height: CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        let boundaryWidth = screenSize.width
        let boundaryHeight = screenSize.height
        let lowerStartPoint = CGPoint(x: 0, y: height)
        let lowerEndPoint = CGPoint(x: boundaryWidth, y: height)
        container.addBoundary(withIdentifier: identifier as NSCopying, from: lowerStartPoint, to: lowerEndPoint)
    }
    
    @objc func keyboardIsShowing() {
        isKeyboardVisible = true
    }
    
    @objc func keyboardIsNotShowing() {
        isKeyboardVisible = false
    }
    
    @objc func sendDragToTop() {
        removeMidBoundaries()
        snapToTop()
        var scrollBool = false
        let dragContentHeight = childVC.dragContent?.preferredContentSize.height
        if childVC.dragContent is MapDetailTestingTableViewController {
            let vc = childVC.dragContent as! MapDetailTestingTableViewController
            let tableViewHeight = vc.tableView.bounds.height
            scrollBool = dragContentHeight! > tableViewHeight
        }
        toggleChildTVCScrolling(shouldScroll: scrollBool, childVC: childVC)
    }
    
    func dragBelowPartialState() {
        if self.frame.origin.y > heightSpec.bottomMidY {
            snapToBottom()
        } else {
            addMidBoundaryTop()
            snapToTop()
        }
    }
    
    func dragAbovePartialState() {
        if self.frame.origin.y < heightSpec.topMidY {
            sendDragToTop()
        } else {
            snapToBottom()
            addMidBoundaryBottom()
        }
    }
    
    func addMidBoundaryTop() {
        guard isPhone() else {
            return
        }
        
        guard isPortrait() else {
            return
        }
        addTopBoundaries(withIdentifier: "midTopBoundary", topHeight: heightSpec.partialStateY)
    }
    
    func addMidBoundaryBottom() {
        guard isPhone() else {
            return
        }
        
        guard isPortrait() else {
            return
        }
        addBottomBoundaries(withIdentifier: "midBottomBoundary", bottomHeight: heightSpec.partialStateHeight)
    }
    
    func removeMidBoundaries() {
        guard container.boundaryIdentifiers != nil else {
            return
        }
        
        for id in container.boundaryIdentifiers! {
            if id as! String == "midTopBoundary" {
                container.removeBoundary(withIdentifier: "midTopBoundary" as NSCopying)
            }
            if id as! String == "midBottomBoundary" {
                container.removeBoundary(withIdentifier: "midBottomBoundary" as NSCopying)
            }
        }
    }
    
    func stopTVCScroll(childVC child: FUIMapDragContentViewController) {
        toggleChildTVCScrolling(shouldScroll: false, childVC: child)
    }
    
    func toggleChildTVCScrolling(shouldScroll scrollBool: Bool, childVC controller: FUIMapDragContentViewController) {
        if controller.dragContent is FUIMapChildViewControllerResizing {
            let scrollableTVC = controller.dragContent as! FUIMapChildViewControllerResizing
            scrollableTVC.tableView.isScrollEnabled = scrollBool
        }
        if controller.dragContent is FUISearchResultsViewController {
            let scrollableTVC = controller.dragContent as! FUISearchResultsViewController
            scrollableTVC.tableView.isScrollEnabled = scrollBool
        }
    }
}
