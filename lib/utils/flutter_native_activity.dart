import 'package:flutter/services.dart';

class FlutterNativeActivity {
  static const MethodChannel _channel = MethodChannel('mint-android-app');

  static Future<String?> startNativeActivity() async {
    final String? result = await _channel.invokeMethod('openMintLib');
    return result;
  }
}