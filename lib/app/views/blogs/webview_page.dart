import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/blogs/qbsc_webview_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';


class QbscWebviewPage extends StatelessWidget {
  const QbscWebviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QbscWebviewController());

    return Scaffold(
      backgroundColor: Colors.white,

      

      body: Column(
        children: [
          // Progress bar
          Obx(
            () => controller.isLoading.value
                ? LinearProgressIndicator(
                    value: controller.progress.value / 100,
                    minHeight: 2,
                  )
                : const SizedBox(height: 2),
          ),

          Expanded(
            child: Obx(
              () {
                if (controller.hasError.value) {
                  return _ErrorView(
                    onRetry: controller.refresh,
                  );
                }

                return WebViewWidget(
                  controller: controller.webViewController,
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                tooltip: 'Back',
                onPressed: controller.goBack,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),

              IconButton(
                tooltip: 'Forward',
                onPressed: controller.goForward,
                icon: const Icon(Icons.arrow_forward_ios),
              ),

              IconButton(
                tooltip: 'Refresh',
                onPressed: controller.refresh,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 70,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              'Halaman tidak dapat dibuka',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Periksa koneksi internet Anda kemudian coba lagi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}