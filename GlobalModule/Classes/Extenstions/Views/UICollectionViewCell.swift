//
//  UICollectionViewCell.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//
import UIKit

extension UICollectionViewCell{
    static var identifier: String {
        return String(describing: self)
    }
    static var nib : UINib{
        return UINib(nibName: identifier, bundle: nil)
    }
}
