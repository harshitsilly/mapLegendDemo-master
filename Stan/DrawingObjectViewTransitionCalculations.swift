//
//  DrawingObjectViewTransitionCalculations.swift
//  AutofittingObjectView
//
//  Created by Stadelman, Stan on 8/5/17.
//  Copyright © 2017 sstadelman. All rights reserved.
//

import UIKit

extension DrawingObjectView {
    func prepareTransitionStep(withOffset offset: CGFloat) {
        self.isTransitioning = true
    }
    
    func endTransition() {
        self.isTransitioning = false
    }
}
