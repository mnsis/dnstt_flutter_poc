import Flutter
import UIKit
import DNSTT

public class DnsttMobilePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dnstt_mobile", binaryMessenger: registrar.messenger())
    let instance = DnsttMobilePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startTunnel":
      guard let args = call.arguments as? [String: Any],
            let domain = args["domain"] as? String,
            let pubkey = args["pubkey"] as? String,
            let resolver = args["resolver"] as? String else {
        result(FlutterError(code: "invalid_args", message: "Missing tunnel arguments", details: nil))
        return
      }

      // NOTE: gomobile bind exports package-level funcs as class methods on DNSTT + packageName
      let started = DNSTTDnsttwrap.startTunnel(withDomain: domain, pubkey: pubkey, resolver: resolver)
      result(started)

    case "stopTunnel":
      DNSTTDnsttwrap.stopTunnel()
      result(nil)

    case "status":
      let running = DNSTTDnsttwrap.isRunning()
      let lastError = DNSTTDnsttwrap.lastError()
      result([
        "running": running,
        "lastError": lastError,
      ])

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
