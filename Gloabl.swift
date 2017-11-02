//
//  FUIMapViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/26/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

func isPortrait() -> Bool {
    return (UIScreen.main.bounds.height > UIScreen.main.bounds.width)
}

func modalPresentationDirection() -> PresentationDirection {
    if (isPortrait()) {
        return .bottom
    } else {
        return .left
    }
}
