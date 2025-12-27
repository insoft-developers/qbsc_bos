import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResumeKandang extends StatefulWidget {
  final String url;
  final String title;

  const ResumeKandang({super.key, required this.url, required this.title});

  @override
  State<ResumeKandang> createState() => _ResumeKandangState();
}

class _ResumeKandangState extends State<ResumeKandang> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Resume Kandang',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
