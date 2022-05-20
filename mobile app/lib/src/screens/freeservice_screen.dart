import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FreeServiceScreen extends StatefulWidget {
  const FreeServiceScreen({required this.url, Key? key}) : super(key: key);

  final String url;

  @override
  _FreeServiceScreenState createState() => _FreeServiceScreenState();
}

class _FreeServiceScreenState extends State<FreeServiceScreen> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        ),
      ),
    );
  }
}
