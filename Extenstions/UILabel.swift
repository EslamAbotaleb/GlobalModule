//
//  UILabel.swift
//  GlobalModule
//
//  Created by Eslam on 28/11/2024.
//

import UIKit

public extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
    func setLetterSpacing(_ spacing: CGFloat) {
        guard let labelText = text, labelText.count > 0 else { return }

        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }

    func addLeading(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
    func truncateTextIfNeeded(maxLines: Int = 2, truncationSuffix: String = "...") {
        guard let text = self.text, numberOfLines == 0 else {
            return
        }

        // Temporarily set number of lines to 0 to calculate the text size
        let originalNumberOfLines = numberOfLines
        numberOfLines = 0

        // Create a temporary UILabel for measurement
        let tempLabel = UILabel()
        tempLabel.numberOfLines = 0
        tempLabel.font = self.font
        tempLabel.text = text
        tempLabel.frame.size = CGSize(width: self.frame.width, height: .greatestFiniteMagnitude)

        let maxHeight = self.font.lineHeight * CGFloat(maxLines)
        var textSize = tempLabel.sizeThatFits(tempLabel.frame.size)

        if textSize.height > maxHeight {
            var truncatedText = text
            var truncationWidth = self.frame.width - self.font.pointSize

            // Truncate the text until it fits within the allowed number of lines
            while textSize.height > maxHeight {
                let index = truncatedText.index(truncatedText.endIndex, offsetBy: -1)
                truncatedText = String(truncatedText[..<index]) + truncationSuffix
                tempLabel.text = truncatedText
                tempLabel.sizeToFit()
                textSize = tempLabel.sizeThatFits(tempLabel.frame.size)
            }

            self.text = truncatedText
        }

        numberOfLines = originalNumberOfLines
    }
    func customizeImageBehindText(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool,lAttachment: NSTextAttachment) {
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = image.size.width  / (image.size.height )

        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)

        let lAttachmentString = NSAttributedString(attachment: lAttachment)

        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString

            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }

            self.attributedText = lStrLabelText
        }
    }
}
