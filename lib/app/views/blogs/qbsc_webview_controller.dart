import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class QbscWebviewController extends GetxController {
  late final WebViewController webViewController;

  final RxInt progress = 0.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  late String url;
  late String title;

  @override
  void onInit() {
    super.onInit();

    url = Get.arguments?['url'] ?? 'https://qbsc.cloud/blogs';
    title = Get.arguments?['title'] ?? 'QBSC';

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) {
            progress.value = value;
          },
          onPageStarted: (_) {
            isLoading.value = true;
            hasError.value = false;
          },
          onPageFinished: (_) {
            isLoading.value = false;
          },
          onWebResourceError: (_) {
            isLoading.value = false;
            hasError.value = true;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  Future<void> refresh() async {
    hasError.value = false;
    await webViewController.reload();
  }

  Future<void> goBack() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
    } else {
      Get.back();
    }
  }

  Future<void> goForward() async {
    if (await webViewController.canGoForward()) {
      await webViewController.goForward();
    }
  }
}