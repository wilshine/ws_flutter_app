import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WSWebView extends StatefulWidget {
  WSWebView({super.key, required this.url});

  String url;

  @override
  State<WSWebView> createState() => WSWebViewState();
}

class WSWebViewState extends State<WSWebView> {
  late WebViewController controller;

  String? title;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            //
          },
          onPageStarted: (String url) {
            //
          },
          onPageFinished: (String url) {
            //
            // () async {
            //   title = await controller.getTitle() ?? '';
            //   setState(() {});
            // }();
          },
          onWebResourceError: (WebResourceError error) {
            //
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: CupertinoButton(
          onPressed: () {
            onEventBack();
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }

  /// Events
  void onEventBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
    } else {
      Navigator.pop(context);
    }
  }
}
