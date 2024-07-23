

library mint_sdk;
import 'package:flutter/cupertino.dart';
import 'package:mintsamplle/utils/Utils.dart';
import 'package:mintsamplle/utils/flutter_native_activity.dart';

typedef MintSDKBuilder = Widget Function(
    BuildContext context, Widget child);

class MintSDK{
  final String domain;
  MintSDK(this.domain);
/**
 *
 * */
  void invokSDK(Map<String, String> jsonArray) async {
    try {
      try {
       /* if (isPlatformAndroid()) {
          await MintUtils.platform.invokeMethod('openMintLib', jsonArray);
        } else {
          await MintUtils.platform.invokeMethod('openMintLibIOS', jsonArray);
        }*/

        String? result = await
        FlutterNativeActivity.startNativeActivity();
        print("MINTSDK   res: $result");
      } catch (e) {
        printlog('MintSDK: $e');
      }
    } catch (e) {
      printlog('MintSDK: $e');
    }
  }

  void printlog(String? message){
    print("$message");
  }

}