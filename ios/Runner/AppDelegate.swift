import UIKit
import Flutter

import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< HEAD
    GMSServices.provideAPIKey("AIzaSyBq2UDv06T3sTpS_Og0GNOTBbya1j55H1w")
=======
    GMSServices.provideAPIKey("YOUR_API_KEY")
    
>>>>>>> 73927b485da40f55d4b9e4292ef0ef12897a343d
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
