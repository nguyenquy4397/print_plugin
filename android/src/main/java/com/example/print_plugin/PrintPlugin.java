package com.example.print_plugin;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** PrintPlugin */
public class PrintPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "print_plugin");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("sendBytes")){
      ArrayList<Integer> bytes = Objects.requireNonNull(call.argument("bytes"));
      String ip = call.argument("ip");
      int port =  call.argument("port") != null ? call.argument("port") : 0;
      int partSize =  call.argument("partSize") != null ? call.argument("partSize") : 0;
      int timeDelay =  call.argument("timeDelay") != null ? call.argument("timeDelay") : 0;
      new CustomSocket(bytes, ip, port, partSize, timeDelay);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
