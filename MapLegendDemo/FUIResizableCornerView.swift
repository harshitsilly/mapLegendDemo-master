//
//  FUIResizableCornerView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 8/8/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIResizableCornerView: UIView {
    
    var searchSpec = FUISearchBarCornerSpec()
    
    var detailVC: UIViewController? = nil
    var searchResultsVC: FUISearchResultsViewController? = nil
    
    var searchHeightConstraint: NSLayoutConstraint? = nil
    var detailHeightConstraint: NSLayoutConstraint? = nil
    var navController: UINavigationController? = nil
    var navTransition: CATransition? = nil
    var parentVC: UIViewController? = nil
    
    func setup(parentController parent: UIViewController) {
        self.parentVC = parent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupSearchView() {
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.handleTableResize(notification:)), name: Notification.Name("preferredContentDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.handleTableResize(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.notifyChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let searchView = searchResultsVC!.view
        parentVC!.view.addSubview(searchView!)
        parentVC!.addChildViewController(searchResultsVC!)
        searchResultsVC!.didMove(toParentViewController: parentVC)
        searchView!.translatesAutoresizingMaskIntoConstraints = false
        searchView!.topAnchor.constraint(equalTo: parentVC!.view.topAnchor, constant: searchSpec.searchBarCornerTopPadding).isActive = true
        searchView!.leadingAnchor.constraint(equalTo: parentVC!.view.leadingAnchor, constant: searchSpec.searchBarCornerLeftPadding).isActive = true
        searchView!.widthAnchor.constraint(equalToConstant: searchSpec.searchBarCornerWidth).isActive = true
        
        searchHeightConstraint = searchView!.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - searchSpec.searchBarCornerTopPadding - searchSpec.searchBarCornerBottomPadding)
        searchHeightConstraint!.isActive = true
        searchView!.layer.cornerRadius = 10
        searchView!.layer.masksToBounds = true
    }
    
    var count = 0
    
    @objc func notifyChange() {
        count += 1
        print("ORIENTATION CHANGE!: \(count)")
    }
    
    @objc func handleTableResize(notification: Notification?) {
        DispatchQueue.main.async {
            print("ORIENTATION CHANGE: 🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾🎾")
            for vc in [self.searchResultsVC, self.detailVC] as [UIViewController?] {
                var shouldScroll = false
                guard vc != nil else {
                    return
                }

                var maxAcceptableHeight = getScreenHeight() - self.searchSpec.searchBarCornerTopPadding - self.searchSpec.searchBarCornerBottomPadding
                var height = isPhone() ? maxAcceptableHeight : vc!.preferredContentSize.height

                guard height != 0 else {
                    return
                }

                if height > maxAcceptableHeight {
                    height = maxAcceptableHeight
                    shouldScroll = true
                }

                if vc is FUISearchResultsViewController {
                    let searchVC = vc as! FUISearchResultsViewController
                    searchVC.tableView.isScrollEnabled = shouldScroll
                    self.searchHeightConstraint?.constant = height
                }
                if vc is MapDetailTestingTableViewController {
                    let detailVC = vc as! MapDetailTestingTableViewController
                    detailVC.tableView.isScrollEnabled = shouldScroll
                    self.detailHeightConstraint?.constant = height
                }

                self.parentVC!.updateViewConstraints()
            }
        }
    }
    
    func setupDetailView(childController child: UIViewController) {
        detailVC = child
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.handleTableResize(notification:)), name: Notification.Name("preferredContentDidChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.pushDetailView), name: Notification.Name("searchItemSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FUIResizableCornerView.handleTableResize(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        let clearRootVC = UIViewController()
        clearRootVC.view.backgroundColor = .clear
        clearRootVC.view.isUserInteractionEnabled = false
        
        navController = UINavigationController(rootViewController: clearRootVC)
        navController!.view.isUserInteractionEnabled = false
        navController!.isNavigationBarHidden = true
        parentVC!.view.addSubview(navController!.view)
        
        parentVC!.addChildViewController(navController!)
        navController!.addChildViewController(clearRootVC)
        clearRootVC.didMove(toParentViewController: navController)
        navController!.didMove(toParentViewController: parentVC!)
        navController!.view.translatesAutoresizingMaskIntoConstraints = false
        navController!.view.topAnchor.constraint(equalTo: parentVC!.view.topAnchor, constant: searchSpec.searchBarCornerTopPadding).isActive = true
        navController!.view.leadingAnchor.constraint(equalTo: parentVC!.view.leadingAnchor, constant: searchSpec.searchBarCornerLeftPadding).isActive = true
        navController!.view.widthAnchor.constraint(equalToConstant: searchSpec.searchBarCornerWidth).isActive = true
        
        detailHeightConstraint = navController!.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - searchSpec.searchBarCornerTopPadding - searchSpec.searchBarCornerBottomPadding)
        detailHeightConstraint!.isActive = true
        navController!.view.layer.cornerRadius = 10
        navController!.view.layer.masksToBounds = true
        
        navTransition = CATransition()
        navTransition!.duration = 0.45
        navTransition!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        navTransition!.type = kCATransitionMoveIn;
        navTransition!.subtype = kCATransitionFromLeft;
    }
    
    func configNavControllerPushLeft() {
        navController!.view.layer.removeAllAnimations()
        navTransition!.type = kCATransitionMoveIn;
        navTransition!.subtype = kCATransitionFromLeft;
        navController!.view.layer.add(navTransition!, forKey: nil)
    }
    
    func configNavControllerPopRight() {
        navController!.view.layer.removeAllAnimations()
        navTransition!.type = kCATransitionPush
        navTransition!.subtype = kCATransitionFromRight
        navController!.view.layer.add(navTransition!, forKey: kCATransition)
    }
    
    @objc func pushDetailView() {
        let detailView = detailVC!.view
        configNavControllerPushLeft()
        navController?.pushViewController(detailVC!, animated: false)
        handleTableResize(notification: nil)
        configTableScroll(isPush: true)
        hideSearchView(isPush: true)
    }
    
    @objc func popDetailView() {
        configNavControllerPopRight()
        navController?.popViewController(animated: false)
        configTableScroll(isPush: false)
        hideSearchView(isPush: false)
    }
    
    func configTableScroll(isPush pushBool: Bool) {
        navController!.view.isUserInteractionEnabled = pushBool
    }
    
    func hideSearchView(isPush pushBool: Bool) {
        var alpha: CGFloat = pushBool ? 0.0 : 1.0
        UIView.animate(withDuration: 0.5, animations: {
            if self.searchResultsVC != nil {
                self.searchResultsVC!.view.alpha = alpha
            }
        })
    }

}
