//
//  TestViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/11/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = 50
        
        let shapeLayer: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.strokeStart = 0.0
            layer.lineJoin = kCALineJoinMiter
            layer.lineDashPattern = [10,8]
            layer.lineDashPhase = 3.0
            layer.strokeColor = UIColor.blue.cgColor
            layer.fillColor = UIColor.white.cgColor
            layer.lineWidth = 6.0
            layer.position = CGPoint(x: 0, y: 0)
            return layer
        }()
        
        // create a new UIView and add it to the view controller
        let myView = FUIMapLegendLinePathView()
        myView.lineLayer = shapeLayer
        myView.frame = CGRect(x: 100, y: 100, width: width, height: 50)

        view.addSubview(myView)
        
        testLabel.attributedText = createMutableIconImage("swag")
        
        let myView2 = FUIMapLegendLinePathView()
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.bounds = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        shapeLayer2.lineWidth = 2.0
        shapeLayer2.fillColor = UIColor.black.cgColor
        shapeLayer2.path = UIBezierPath(rect: shapeLayer2.bounds).cgPath
        shapeLayer2.strokeColor = UIColor.green.cgColor
        myView2.lineLayer = shapeLayer2
        myView2.frame = CGRect(x: 200, y: 200, width: width, height: 50)
        view.addSubview(myView2)
        
    }

    func createMutableIconImage(_ str: String) -> NSMutableAttributedString {
        // Try Image
        let attributedString = NSMutableAttributedString(string: " ")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "sword_16")
        //        let oldWidth = textAttachment.image?.size.width
        //        let scaleFactor = oldWidth!/(itemCell.iconTextView.frame.size.width)
        //        textAttachment.image = UIImage(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.replaceCharacters(in: NSMakeRange(0, 1), with: attrStringWithImage)
        return attributedString
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
