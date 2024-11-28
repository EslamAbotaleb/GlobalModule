//
//  UIButton.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//


import UIKit

public class LocalizedButton: UIButton{
    
    public override func awakeFromNib() {
        DispatchQueue.global().async {
            // Perform file-related operations here, such as accessing the bundle path
            let bundlePath = Bundle.main.bundlePath

            // Once the operations are complete, update the UI on the main thread if needed
            DispatchQueue.main.async {
                self.setTitle(self.currentTitle?.localized, for: .normal)
            }
        }

    }
}

public class LocalizedUITabBarItem: UITabBarItem{
    public override init() {
        super.init()
        self.title = self.title?.localized
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = self.title?.localized
    }
    public override func awakeFromNib() {
        self.title = self.title?.localized

    }
}
public extension UIButton {
    func selectedButton(title: String, iconName: String, widthConstraints: NSLayoutConstraint, fontType: UIFont, titleColor: UIColor, languageNotEnglish: Bool) {
        self.backgroundColor = UIColor.clear

        // Set the title and image for the normal state
        self.setTitle(title, for: .normal)
        self.setImage(UIImage(named: iconName), for: .normal)

        // Configure the button appearance
        self.titleLabel?.font = fontType
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.textAlignment = languageNotEnglish ? .right : .left
        self.layoutIfNeeded()
    }
}

public extension UIButton{
    func addTextSpacing(_ spacing: CGFloat){
        let attributedString = NSMutableAttributedString(string: title(for: .normal) ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.string.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
