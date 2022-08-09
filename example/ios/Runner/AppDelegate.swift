import UIKit
import Flutter

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    let  output = items.map { "*\($0)"}.joined(separator: " ")
    Swift.print(output, terminator: terminator)
    NSLog(output)
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
