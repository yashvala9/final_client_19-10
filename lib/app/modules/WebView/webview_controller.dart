import 'dart:async';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebController extends GetxController {
  final RxBool isLoading = true.obs;

  late WebViewController _rootwebViewController;

  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  final RxnString webViewUrl = RxnString();

  void onWebViewCreated(WebViewController _controller) async {
    _webViewController.future.then(
      (WebViewController value) => _rootwebViewController = _controller,
    );
    _webViewController.complete(_controller);
  }

  void onWebViewLoaded(_) async {
    await _rootwebViewController.currentUrl().then((String? _url) {
      webViewUrl(_url);
    });
    isLoading(false);
  }

  Future<bool> handleMagazineViewBack() async {
    if (await _rootwebViewController.canGoBack()) {
      _rootwebViewController.goBack();
      return false;
    } else {
      return true;
    }
  }
}
