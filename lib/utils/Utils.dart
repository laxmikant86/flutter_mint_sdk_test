import 'dart:io';

import 'package:flutter/services.dart';

class MintUtils {
  static const platform = MethodChannel('mint-android-app');
}

bool isPlatformAndroid() {
  return Platform.isAndroid;
}
