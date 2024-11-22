
import Foundation
import UIKit
import ObjectiveC

public class LoggerModule {
    public init(){}
    public func printLog() {
        print("Hello world")
    }
    
}
extension UIImageView {
   public func circleImageView(borderColor: UIColor, borderWidth: CGFloat){
       self.layer.borderColor = borderColor.cgColor
       self.layer.borderWidth = borderWidth
       self.layer.cornerRadius = self.layer.frame.size.width / 2
       self.clipsToBounds = true
   }
}
