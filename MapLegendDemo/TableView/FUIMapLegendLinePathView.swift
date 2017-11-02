//
//  FUIMapLegendLinePathView.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/11/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//
import UIKit

let customLineWidth: CGFloat = 6.0
let lineWidth: CGFloat = 28

class FUIMapLegendLinePathView: UIView {
    
    var spec: FUIMapLegendSpec = FUIMapLegendSpec()
    
    var lineLayer: CAShapeLayer? = nil {
        didSet {
            DispatchQueue.main.async {
                self.setup()
            }
            
        }
    }
    
    private var linePath: UIBezierPath = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y: customLineWidth / 2))
        path.addLine(to: CGPoint(x: lineWidth,y: customLineWidth / 2))
        return path
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        guard (lineLayer != nil) else {
            return
        }

        lineLayer!.path = linePath.cgPath
        lineLayer!.lineWidth = customLineWidth
        lineLayer!.contentsScale = UIScreen.main.scale
        layer.addSublayer(lineLayer!)
//        lineLayer?.backgroundColor = UIColor.clear.cgColor
//        layer.backgroundColor = UIColor.clear.cgColor
        lineLayer!.bounds = layer.bounds
        setNeedsDisplay()
    }
    
//    override func draw(_ rect: CGRect) {
//        print("i got here")
//        lineLayer?.bounds = layer.bounds
//
//    }
    
//    override func draw(_ rect: CGRect) {
////        self.linePath?.stroke()
//        guard (self.lineLayer != nil) else {
//            return
//        }
//        self.lineLayer!.draw(in: UIGraphicsGetCurrentContext()!)
////        let c = UIGraphicsGetCurrentContext()!
////        c.saveGState()
////        guard (self.lineLayer != nil) else {
////            return
////        }
////        self.draw(self.lineLayer!, in: c)
////        c.restoreGState()
//    }
}
