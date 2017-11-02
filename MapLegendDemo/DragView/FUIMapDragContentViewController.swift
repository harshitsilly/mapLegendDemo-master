//
//  FUIMapDragContentViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/31/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapDragContentViewController: UIViewController {
    var heightSpec = FUIDragHeightSpec()
    var dragSpec = SearchDragSpec()
    var dragContent: UIViewController? = nil
    var dragView: UIView? = nil
    var dragContentBottomConstraint: NSLayoutConstraint? = nil

    init(dragContent givenDragContent: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.dragContent = givenDragContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        self.view.accessibilityIdentifier = "$DragContentVC"
    }
    
    @objc func keyboardNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            dragContentBottomConstraint!.isActive = false
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                dragContentBottomConstraint = dragContent!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightSpec.topBoundaryY)
            } else {
                let keyBoardHeight = endFrame?.size.height ?? 0.0
                dragContentBottomConstraint = dragContent!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightSpec.topBoundaryY - keyBoardHeight)
            }
            dragContentBottomConstraint!.isActive = true
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded()
                            self.dragContent?.view.updateConstraints()
                            },
                           completion: nil)
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            let width = UIScreen.main.bounds.width - dragSpec.searchBarDragleftPadding - dragSpec.searchBarDragrightPadding
            let height = dragContent!.preferredContentSize.height + dragSpec.dragHandleHeight + dragSpec.dragHandleTopPadding + dragSpec.dragHandleBotttomPadding
            return CGSize(width: width, height: height)
        }
        set {}
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("FUIMapDragContentViewController DEINIT")
    }
    
    func setup() {
        setupDragHandle()
        setupContentVC()
    }
    
    func setupDragHandle() {
        if isPhone() {
            dragView = UIView()
            self.view.addSubview(dragView!)
            dragView?.accessibilityIdentifier = "$DragHandle"
            dragView!.backgroundColor = UIColor.black
            dragView?.layer.cornerRadius = 4
            dragView!.translatesAutoresizingMaskIntoConstraints = false
            dragView!.heightAnchor.constraint(equalToConstant: dragSpec.dragHandleHeight).isActive = true
            dragView!.widthAnchor.constraint(equalToConstant: dragSpec.dragHandleWidth).isActive = true
            dragView!.topAnchor.constraint(equalTo: view.topAnchor, constant: dragSpec.dragHandleTopPadding).isActive = true
            dragView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    func setupContentVC() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: dragView!.bottomAnchor, constant: dragSpec.dragHandleBotttomPadding).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        addChildViewController(dragContent!)
        dragContent!.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dragContent!.view)
        dragContent!.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dragContent!.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dragContent!.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dragContentBottomConstraint = dragContent!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -heightSpec.topBoundaryY)
        dragContentBottomConstraint?.identifier = "$DragContentbottomConstraint"
        
        dragContentBottomConstraint!.isActive = true
        dragContent!.didMove(toParentViewController: self)
    }
}
