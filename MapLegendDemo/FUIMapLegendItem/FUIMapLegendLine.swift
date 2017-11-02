//
//  FUIMapLegendLine.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/13/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapLegendLine {
    
    private var strokeColor: UIColor
    private var lineWidth:CGFloat = 6
    private var lineLayer: CAShapeLayer? = nil
    private var lineDashPattern: [NSNumber]? = nil
    private var lineDashPhase: CGFloat? = nil
    
    init(color strokeColor: UIColor) {
        self.strokeColor = strokeColor
        setLineLayer()
    }
    
    init(color givenColor: UIColor, lineDashPattern dashPattern: [NSNumber], lineDashPhase dashPhase: CGFloat) {
        self.strokeColor = givenColor
        self.lineDashPattern = dashPattern
        self.lineDashPhase = dashPhase
        setLineLayer()
    }
    
    private func setLineLayer() {
        let layer = CAShapeLayer()
        layer.strokeStart = 0.0
        layer.strokeColor = self.strokeColor.cgColor
        layer.lineWidth = self.lineWidth
        layer.position = CGPoint(x: 0, y: 0)
        layer.lineDashPattern = self.lineDashPattern
        if (self.lineDashPhase != nil) {
            layer.lineDashPhase = self.lineDashPhase!
        }
        self.lineLayer = layer
    }
    
    func getLayer() -> CAShapeLayer {
        return self.lineLayer!
    }

}
