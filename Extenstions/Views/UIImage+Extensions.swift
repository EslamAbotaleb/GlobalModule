//
//  UIImage+Extensions.swift
//  CERQEL
//
//  Created by HassanElshair on 06/04/2022.
//  Copyright © 2022 Youxel. All rights reserved.
//

import Foundation
import UIKit
//import InitialsImageView


public extension UIImage {

    /// place the imageView inside a container view
    /// - parameter superView: the containerView that you want to place the Image inside
    /// - parameter width: width of imageView, if you opt to not give the value, it will take default value of 100
    /// - parameter height: height of imageView, if you opt to not give the value, it will take default value of 30
    func addToCenter(of superView: UIView, width: CGFloat = 100, height: CGFloat = 30) {
        let overlayImageView = UIImageView(image: self)

        overlayImageView.translatesAutoresizingMaskIntoConstraints = false
        overlayImageView.contentMode = .scaleAspectFit
        superView.addSubview(overlayImageView)

        let centerXConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: overlayImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let height = NSLayoutConstraint(item: overlayImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let centerYConst = NSLayoutConstraint(item: overlayImageView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)

        NSLayoutConstraint.activate([width, height, centerXConst, centerYConst])
    }

    convenience init(withBackground color: UIColor) {

        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        context.setFillColor(color.cgColor);
        context.fill(rect)

        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(ciImage: CIImage(image: image)!)

    }

    func maskRoundedImage(radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: self)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }

    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
public extension UIImage {
    func colorImage(with color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContext(self.size)
        let contextRef = UIGraphicsGetCurrentContext()

        contextRef?.translateBy(x: 0, y: self.size.height)
        contextRef?.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        contextRef?.setBlendMode(CGBlendMode.normal)
        contextRef?.draw(cgImage, in: rect)
        contextRef?.setBlendMode(CGBlendMode.sourceIn)
        color.setFill()
        contextRef?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage
    }


    /// Tint, Colorize image with given tint color
    /// This is similar to Photoshop's "Color" layer blend mode
    /// This is perfect for non-greyscale source images, and images that
    /// have both highlights and shadows that should be preserved<br><br>
    /// white will stay white and black will stay black as the lightness of
    /// the image is preserved
    ///
    /// - Parameter TintColor: Tint color
    /// - Returns:  Tinted image
     func tintImage(with fillColor: UIColor) -> UIImage {

        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            //                UIColor.black.setFill()
            UIColor.white.setFill()

            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage!, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            fillColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(context.makeImage()!, in: rect)
        }
    }

    /// Modified Image Context, apply modification on image
    ///
    /// - Parameter draw: (CGContext, CGRect) -> ())
    /// - Returns:        UIImage
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {

        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}

public extension UIImage {
    func tinted(with color: UIColor, isOpaque: Bool = false) -> UIImage? {
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
}
public extension UIImage {
    func flippedcheckmarkImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: self.size.width, y: 0)
        context?.scaleBy(x: -1, y: 1)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let flippedCheckMarkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedCheckMarkImage
    }
}
public extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
}
public extension UIImage {
    convenience init?(color: UIColor, size: CGSize? = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size ?? CGSize(width: 0, height: 0))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image!.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
