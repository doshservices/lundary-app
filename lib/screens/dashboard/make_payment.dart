import 'package:laundry_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:io';
import 'package:laundry_app/utils/appalertdialog.dart';
import 'package:provider/provider.dart';
import 'package:laundry_app/providers/cart.dart';

class MakePayment extends StatefulWidget {
  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool _isFirstTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: "${arguments['confirmationUrl']}",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: <JavascriptChannel>[].toSet(),
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) async {
              print(url);
              Uri link = Uri.parse(url);

              //https://mima-ui-service.netlify.app/?trxref=e6ls6ob8wi&reference=e6ls6ob8wi

              print("host ${link.host}");
              //https://nathansdrycleaners.com/

              if (link.host == "nathansdrycleaners.com") {
                dynamic ref = link.queryParameters["trxref"];
                if (_isFirstTime) {
                  AppAlertDialog.ShowDialog(context, "Verifying payment");
                  setState(() {
                    _isFirstTime = false;
                  });
                  try {
                    await Provider.of<ServiceProvider>(context, listen: false)
                        .verifyOrder(ref);
                    Navigator.of(context, rootNavigator: true).pop();

                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text("Order Successful"),
                            actions: [
                              RaisedButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                    Provider.of<CartProvider>(context, listen: false)
                        .clearCART();

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        kDashboardScreen, (route) => false);
                  } catch (error) {
                    print(error);
                    Navigator.of(context, rootNavigator: true).pop();
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Text("$error"),
                            actions: [
                              RaisedButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        kDashboardScreen, (route) => false);
                  }
                }
              }
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          );
        }),
      ),
    );
  }
}
