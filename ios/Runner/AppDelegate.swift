import Flutter
import UIKit
import Contacts // Stelle sicher, dass Contacts importiert ist, falls noch nicht geschehen

@main
@objc class AppDelegate: FlutterAppDelegate {

  let contactChannelName = "de.jessicaernst.brainbench/contacts" 

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }

    let contactChannel = FlutterMethodChannel(name: contactChannelName,
                                              binaryMessenger: controller.binaryMessenger)

    contactChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      ContactHelper.handle(call: call, result: result)
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func checkContactsPermission(result: @escaping FlutterResult) {
      let store = CNContactStore()
      let status = CNContactStore.authorizationStatus(for: .contacts)

      switch status {
      case .authorized:
          result(true)
      case .denied, .restricted:
          result(FlutterError(code: "PERMISSION_DENIED", message: "Contact access denied or restricted", details: nil))
      case .notDetermined:
          store.requestAccess(for: .contacts) { granted, error in
              if let error = error {
                  result(FlutterError(code: "PERMISSION_ERROR", message: "Error requesting contact access: \(error.localizedDescription)", details: nil))
                  return
              }
              if granted {
                  result(true)
              } else {
                  result(FlutterError(code: "PERMISSION_DENIED", message: "Contact access denied by user", details: nil))
              }
          }
      @unknown default:
          result(FlutterError(code: "UNKNOWN_STATUS", message: "Unknown contact authorization status", details: nil))
      }
  }
}
