import UIKit
import Flutter
import MintFrameworks
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      if let navigationController = window?.rootViewController as? UINavigationController {
          // Use the navigationController
          let controller : FlutterViewController = navigationController.topViewController as! FlutterViewController
             let mintChannel = FlutterMethodChannel(name: "mint-android-app", binaryMessenger: controller.binaryMessenger)
             
             mintChannel.setMethodCallHandler({
                 (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                 if call.method == "openMintLibIOS" {
                     guard let args = call.arguments as? [String: Any],
                           let ssoToken = args["ssoToken"] as? String,
                           let fcmToken = args["fcmToken"] as? String,
                           let domain = args["domain"] as? String else {
                         result(FlutterError(code: "INVALID_ARGS",
                                             message: "Invalid arguments",
                                             details: nil))
                         return
                     }
                     
                     self.invokeMintSDK(ssoToken: ssoToken, fcmToken: fcmToken, domain: domain)
                     result("Success")
                 } else {
                     result(FlutterMethodNotImplemented)
                 }
             })
      }
     
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
     private func invokeMintSDK(ssoToken: String, fcmToken: String, domain: String) {
        // Implement your MintSDK logic here
        print("SSO Token: \(ssoToken)")
        print("FCM Token: \(fcmToken)")
        print("Domain: \(domain)")
         if let navigationController = window?.rootViewController as? UINavigationController {         MintSDKInvoke().invokeMintApp(domain: domain, token: ssoToken, navigateToview: "", nav: navigationController)
         }
    }
}
