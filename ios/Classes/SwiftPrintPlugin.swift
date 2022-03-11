import Flutter
import UIKit

public class SwiftPrintPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "print_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftPrintPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method){
      case "getPlatformVersion":
            print("getPlatformVersion in ios")
          result("iOS " + UIDevice.current.systemVersion)
          break;
      case "sendBytes":
         NSLog("", "sendBytes in ios")
          var bytes : [Int] = []
          var ip = ""
          var port = 0
          
          if let arguments = call.arguments as? [String: Any] {
              if let t_bytes = arguments["bytes"] as? [Int] {
                 bytes = t_bytes
              }

              if let t_ip = arguments["ip"] as? String {
                  ip = t_ip
              }

            if let t_port = arguments["port"] as? Int {
                  port = t_port
            }
              
          }

          var inp :InputStream?
          var out :OutputStream?
        
         Stream.getStreamsToHost(withName: ip, port: port, inputStream: &inp, outputStream: &out)
          let outputStream = out!
          outputStream.open()
          
          var bytesToUInt8 = bytes.map{UInt8(bitPattern: Int8(truncatingIfNeeded: $0))}
          outputStream.write(&bytesToUInt8, maxLength: bytes.count)
          outputStream.close()
          break
      default:
          result("Not Implemented!")
          break;
      }
      
      }
}
