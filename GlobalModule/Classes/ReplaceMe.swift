
import Foundation
import UIKit
import ObjectiveC

public class LoggerModule {
    public init(){}

    public var toastManger = ToastManager.shared

    public func printLog() {
        print("Hello world")
    }
}
