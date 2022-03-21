import 'dart:io';

import 'package:flutter/cupertino.dart';

class CustomSocket {
  CustomSocket({
    required this.ip,
    required this.port,
    required this.bytes,
    this.partSize,
    this.timeDelay,
  });
  String ip;
  int port;
  List<int> bytes;
  int? partSize;
  int? timeDelay;

  Socket? _socket;

  Future<void> connect() async {
    _socket = await Socket.connect(ip, port);
    if (partSize != null && timeDelay != null) {
      await _socket!.addStream(streamOfBytes(bytes));
      //_socket!.
    } else {
      _socket!.add(bytes);
    }
    //await _socket!.flush();
    _socket!.close();
  }

  Stream<List<int>> streamOfBytes(List<int> bytes) async* {
    for (int i = 0; i < bytes.length; i += partSize!) {
      await Future.delayed(Duration(milliseconds: timeDelay ?? 0));
      yield bytes.sublist(i, i + partSize!);
    }
  }
}
