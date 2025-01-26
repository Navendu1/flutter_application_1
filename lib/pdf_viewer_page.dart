import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerPage({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  WebViewController? _controller; // Make it nullable
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _checkPdfUrlValidity();
  }

  Future<void> _checkPdfUrlValidity() async {
    try {
      final response = await http.head(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        // URL is valid, initialize WebView
        _initializeWebViewController();
      } else {
        // URL is invalid
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      // Handle network errors or invalid URLs
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _initializeWebViewController() {
    // Encode the PDF URL to use with Google Docs Viewer
    String encodedUrl = Uri.encodeComponent(widget.pdfUrl);
    String googleDocsUrl =
        'https://docs.google.com/viewer?url=$encodedUrl&embedded=true';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(googleDocsUrl));

    // Ensure the WebView is rebuilt after initialization
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_controller != null && !_hasError)
            WebViewWidget(controller: _controller!),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_hasError)
            Center(
              child: Text(
                'Result not found.', // change with your appropriate text
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
