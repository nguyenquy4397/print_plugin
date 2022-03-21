import 'dart:async';

import 'package:flutter/services.dart';
import 'package:print_plugin/custom_socket.dart';

class PrintPlugin {
  static const MethodChannel _channel = MethodChannel('print_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> sendBytes({
    required List<int> bytes,
    required String ip,
    required int port,
    int? partSize,
    int? timeDelay,
    bool isUseNativeSocket = true,
  }) async {
    if (isUseNativeSocket) {
      print('use native socket');
      final result = await _channel.invokeMethod("sendBytes", {
        "bytes": bytes,
        "ip": ip,
        "port": port,
        "partSize": partSize ?? 0,
        "timeDelay": timeDelay ?? 0,
      });
    } else {
      print('use dart socket');
      final customSocket = CustomSocket(
        ip: ip,
        port: port,
        bytes: bytes,
        partSize: partSize,
        timeDelay: timeDelay,
      );
      await customSocket.connect();
    }
  }
}
