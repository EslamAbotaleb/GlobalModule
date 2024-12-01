//
//  PieChartView.swift
//  CERQEL
//
//  Created by Marwan on 25/05/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import UIKit

@IBDesignable
public class PieChartView: UIView {

    private let activeLayer = CAShapeLayer()
    private let inActiveLayer = CAShapeLayer()
    
    @IBInspectable var lineWidth: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var inActiveColor: UIColor = .black.withAlphaComponent(0.15) {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var activeColor: UIColor = .blue {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var progress: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable var lineCap: CAShapeLayerLineCap = .square {
        didSet { setNeedsDisplay() }
    }
    
    public override func draw(_ rect: CGRect) {
        let radius = max(bounds.size.width, bounds.size.height) - lineWidth
                        
        let inActivePath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        inActiveLayer.path = inActivePath.cgPath
        inActiveLayer.lineWidth = lineWidth
        inActiveLayer.fillColor = UIColor.white.cgColor
        inActiveLayer.strokeColor = inActiveColor.cgColor
        inActiveLayer.strokeStart = 0
        inActiveLayer.strokeEnd = 1
        
        let activePath = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        activeLayer.path = activePath.reversing().cgPath
        activeLayer.lineWidth = lineWidth
        activeLayer.fillColor = UIColor.clear.cgColor
        activeLayer.strokeColor = activeColor.cgColor
        activeLayer.strokeStart = 0
        activeLayer.strokeEnd = progress
        activeLayer.lineCap = lineCap
        
        layer.insertSublayer(inActiveLayer, at: 0)
        layer.insertSublayer(activeLayer, at: 1)
        
    }
    
}
