//
//  CAGradientLayerExtensions.swift
//  GAZT
//
//  Created by iSlam AbdelAziz on 1/18/21.
//  Copyright © 2021 Youxel. All rights reserved.
//

import UIKit

public extension CAGradientLayer {

    convenience init(isVertical: Bool, frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        if isVertical{
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        }else{
            startPoint = CGPoint.init(x: 0, y: 0.5)
            endPoint = CGPoint(x: 1, y: 0.5)
        }
        
    }
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}

public extension CALayer {
  func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.1,
    x: CGFloat = 0,
    y: CGFloat = 0,
    blur: CGFloat = 8,
    spread: CGFloat = 0)
  {
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
