import 'dart:async';

import 'package:flutter/services.dart';

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
  }) async {
    print("sendBytes in flutter");
    final result = await _channel.invokeMethod("sendBytes", {
      "bytes": bytes,
      "ip": ip,
      "port": port,
    });
  }
}
