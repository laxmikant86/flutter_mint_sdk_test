import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mintsamplle/utils/Utils.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              generateAuth('');
            },
                child:Text("Call sdk from Second Screen "))
          ],
        ),
      ),
    );
  }


  Future<dynamic> generateAuth(String loginType) async {
    // Show progress indicator
    setState(() {
      _isLoading = true;
    });

    // API endpoint
    final String url =
        "https://demo.investwell.app/api/aggregator/auth/getAuthorizationToken";

    try {
      // Make POST request

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      Map<String, String> jsonBody = {
        "authName": "demoapi",
        "password": "API@1001"
      };
      final urls = Uri.parse(url);
      final response = await http.post(urls, body: jsonBody);

      // Handle response
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check response status
        if (jsonResponse['status'] == 0) {
          final result = jsonResponse['result'];
          final String token = result['token'];
          print('Success: ${jsonResponse.toString()}');
          // Call another function with token
          getAuthenticationKey(token, "broker");
        } else {
          print('Error: ${jsonResponse.toString()}');
          showToastMessage("Error: ${jsonResponse['message']}");
        }
      } else {
        showToastMessage("Error: ${response.reasonPhrase}");
        print('Success: ${response.reasonPhrase}');
      }
    } catch (error) {
      showToastMessage("Error: $error");
      print('Success: ${error}');
    } finally {
      // Hide progress indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, String> getParams(String token, String type) {
    Map<String, String> params = {
      "token": token,
      "username": type.isEmpty ? "aabcp7138a223" : "",
    };

    return params;
  }

  Future<dynamic> getAuthenticationKey(String token, String type) async {
    // Show progress indicator
    setState(() {
      _isLoading = true;
    });

    // API endpoint
    final String url =
        "https://demo.investwell.app/api/aggregator/auth/getAuthenticationKey";

    try {
      // Make POST request
      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);
      final urls = Uri.parse(url);
      Map<String, String> jsonBody = getParams(token, type);
      final response = await http.post(urls, body: jsonBody);

      // Handle response
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Check response status
        if (jsonResponse['status'] == 0) {
          final result = jsonResponse['result'];
          final String SSOToken = result['SSOToken'];
          print('Success 2 and openSDK: ${jsonResponse.toString()}');
          // invoke sdk
          //preprare jsonobject
          Map<String, String> jso = {
            'ssoToken': '$SSOToken',
            'fcmToken': 'your_fcm_token',
            'domain': 'demo'
          };
          openMintLib(jso);
        } else {
          showToastMessage("Error: ${jsonResponse['message']}");
          print('Success: ${jsonResponse.toString()}');
        }
      } else {
        showToastMessage("Error: ${response.reasonPhrase}");
        print('Success: ${response.reasonPhrase}');
      }
    } catch (error) {
      showToastMessage("Error: $error");
      print('Success: ${error}');
    } finally {
      // Hide progress indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showToastMessage(String message) {
    print("$message");
  }

  void openMintLib(Map<String, String> jsonArray) async {
    try {
      try {
        if (isPlatformAndroid()) {
          await MintUtils.platform.invokeMethod('openMintLib', jsonArray);
        } else {
          await MintUtils.platform.invokeMethod('openMintLibIOS', jsonArray);
        }
      } catch (e) {}
    } catch (e) {
      print('Error: $e');
    }
  }
}
