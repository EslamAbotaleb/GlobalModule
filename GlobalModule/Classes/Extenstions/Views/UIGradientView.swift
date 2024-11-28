//
//  UIGradientView.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//

import UIKit

@IBDesignable
public class UIGradientButton: LocalizedButton {

    @IBInspectable public var firstColor: UIColor = UIColor.clear{
        didSet{
            updateView()
        }
    }
    @IBInspectable public var secondColor: UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    @IBInspectable public var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet{
            updateView()
        }
    }
    @IBInspectable public var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet{
            updateView()
        }
    }

    public override class var layerClass: AnyClass {
        get{
            return CAGradientLayer.self
        }
    }

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor.cgColor , secondColor.cgColor]
        //        layer.locations = [0.5]
        layer.startPoint = startPoint
        layer.endPoint = endPoint
    }
}
