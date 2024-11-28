//
//  UIView.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//

import UIKit

extension UIView {

    func addShadowWith(color: UIColor, radius: CGFloat, opacity: Float?) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity ?? 0.7
    }

    func addShadowWithRadius(cornerRadius: CGFloat?, borderWidth: CGFloat?, borderColor: CGColor?, shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat) {
        // corner radius
        self.layer.cornerRadius = cornerRadius ?? 0

        // border
        self.layer.borderWidth = borderWidth ?? 0
        self.layer.borderColor = borderColor ?? UIColor.black.cgColor

        // shadow
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }

    func addNormalShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2

    }


    func roundCornersss(corners: UIRectCorner, radius: CGFloat, borderWidth: CGFloat?, borderColor: UIColor?) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath

        self.layer.mask = maskLayer
        self.layer.masksToBounds = true

        if (borderWidth != nil && borderColor != nil) {

            // remove previously added border layer
            for layer in layer.sublayers! {
                if layer.name == "borderLayer" {
                    layer.removeFromSuperlayer()
                }
            }

            let borderLayer = CAShapeLayer()

            borderLayer.frame = self.bounds;
            borderLayer.path  = maskPath.cgPath;
            borderLayer.lineWidth = borderWidth ?? 0;
            borderLayer.strokeColor = borderColor?.cgColor;
            borderLayer.fillColor   = UIColor.clear.cgColor;
            borderLayer.name = "borderLayer"
            self.layer.addSublayer(borderLayer);
        }
    }
    func roundSpecificCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }


    @IBInspectable var cornerRadiusV: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidthV: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColorV: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIView {
    // Returns `UIEdgeInsets` set using `leading` and `trailing` modifiers adaptive to the language direction
    func getDirectionalUIEdgeInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) -> UIEdgeInsets {
        // NOTE: this wil be deprecated when Apple use `NSDirectioanlEdgeInsets` (https://developer.apple.com/documentation/uikit/nsdirectionaledgeinsets) for your insets property instead of `UIEdgeInsets`

        if self.userInterfaceLayoutDirection == .leftToRight {
            return UIEdgeInsets(top: top, left: leading, bottom: bottom, right: trailing)
        } else {
            return UIEdgeInsets(top: top, left: trailing, bottom: bottom, right: leading)
        }
    }

    /// Returns text and UI direction based on current view settings
    var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection
    {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute)
        } else {
            return UIApplication.shared.userInterfaceLayoutDirection
        }
    }
}
extension UIView {
    func roundCornersView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
        // Create a path for the shadow
        let shadowPath = UIBezierPath(rect: CGRect(x: bounds.minX, y: bounds.maxY - 1, width: bounds.width, height: 1))
        // Apply the shadow path
        layer.shadowPath = shadowPath.cgPath
        // Set rasterization properties
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadowWithBlurEffect() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 8
        layer.masksToBounds = false // Allow shadow to be visible
        // Apply blur effect to nested view
        let blurEffect = UIBlurEffect(style: .regular) // Choose the desired blur effect style
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurView, at: 0)
        // Apply blur effect to shadow
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10)
        layer.shadowPath = shadowPath.cgPath
    }
}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    @discardableResult
    func constrain(constraints: (UIView) -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = constraints(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func constrainToEdges(_ inset: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return constrain {[
            $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: inset.top),
            $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: inset.left),
            $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: inset.bottom),
            $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: inset.right)
        ]}
    }
}

