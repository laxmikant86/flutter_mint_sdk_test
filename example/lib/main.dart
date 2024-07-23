import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mintsamplle/mint_sdk.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
bool _isLoading = false;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // generateAuth('');
          Map<String, String> jso = {
            'ssoToken': 'mhsbvjdhcbmnbvjhbs',
            'fcmToken': 'your_fcm_token',
            'domain': 'roinetsecurities'
          };
          var mintSdk = MintSDK("roinetsecurities");
          mintSdk.invokSDK(jso);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  Future<dynamic> generateAuth(String loginType) async {
    // Show progress indicator
    setState(() {
      _isLoading = true;
    });

    // API endpoint
    final String url =
        "https://roinetsecurities.investwell.app/api/aggregator/auth/getAuthorizationToken";

    try {
      // Make POST request

      HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);

      Map<String, String> jsonBody = {
        "authName": "RoinetsecApi",
        "password": "roinetsec12345"
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
      "username": type.isEmpty ? "CSP000073" : "CSP000073",
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
        "https://roinetsecurities.investwell.app/api/aggregator/auth/getAuthenticationKey";

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
            'domain': 'roinetsecurities'
          };
         var mintSdk = MintSDK("roinetsecurities");
         mintSdk.invokSDK(jso);
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


  /**
   * var mint = MintSDK("spvithlani");
   *  mint.invokSDK();
   * */
}
