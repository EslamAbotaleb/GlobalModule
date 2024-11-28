//
//  UITextField.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//


import UIKit
public extension UITextField{

    @IBInspectable var paddingRightCustom: CGFloat {
        get {
            return rightView!.frame.size.width
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    enum PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }
    func addPadding(padding: PaddingSpace) {

        self.leftViewMode = .always
        self.layer.masksToBounds = true

        switch padding {

            case .left(let spacing):
                let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.leftView = leftPaddingView
                self.leftViewMode = .always

            case .right(let spacing):
                let rightPaddingView = UIView(frame: CGRect(x: spacing, y: 0, width: spacing, height: self.frame.height))
                self.rightView = rightPaddingView
                self.rightViewMode = .always

            case .equalSpacing(let spacing):
                let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                // left
                self.leftView = equalPaddingView
                self.leftViewMode = .always
                // right
                self.rightView = equalPaddingView
                self.rightViewMode = .always
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    func addIconView(img: UIImage, isRight: Bool = false){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 20))
        let imgV = UIImageView(frame: CGRect(x: 17, y: 1.2, width: 16, height: 16))
        view.addSubview(imgV)
        imgV.image = img
        imgV.contentMode = .scaleAspectFit
        if isRight{
            self.rightView = view
            self.rightViewMode = .always
        }else{
            self.leftView = view
            self.leftViewMode = .always
        }
    }
    func addEmptyView(isLeft: Bool, width: Int){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        if isLeft{
            self.leftView = view
            self.leftViewMode = .always
        }else{
            self.rightView = view
            self.rightViewMode = .always
        }
    }
    func addTitleView(isLeft: Bool, width: Int, text: String, txtColor: UIColor){
        let lbl = UILabel(frame: CGRect(x: 4, y: 0, width: width, height: 20))
        lbl.text = text
        lbl.textColor = txtColor
        lbl.textAlignment = .center
        lbl.font = UIFont.init(name: "Cairo-Regular", size: 11)
        if isLeft{
            self.leftView = lbl
            self.leftViewMode = .always
        }else{
            self.rightView = lbl
            self.rightViewMode = .always
        }
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: -16, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func addPaddingToTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    @objc func modifyClearButton(with image : UIImage) {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(_:)), for: .touchUpInside)
        rightView = clearButton
        rightViewMode = .whileEditing
    }
    @objc func clear(_ sender : AnyObject) {
        self.text = ""
        rightViewMode = .never
    }
}
