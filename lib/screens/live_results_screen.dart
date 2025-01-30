import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/services.dart';

class LiveResultsScreen extends StatefulWidget {
  const LiveResultsScreen({super.key});

  @override
  State<LiveResultsScreen> createState() => _LiveResultsScreenState();
}

class _LiveResultsScreenState extends State<LiveResultsScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // Lock to portrait orientation for better video viewing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Initialize WebView with enhanced settings
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..enableZoom(false)
      ..loadRequest(Uri.parse('about:blank'))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            print('Page load started');
            
            // Set up viewports and scaling when page starts
            _controller.runJavaScript('''
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
              document.head.appendChild(meta);
            ''');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            print('Page load finished');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
            print('Web resource error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading video: ${error.description}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _loadHtmlFromAssets(),
                ),
              ),
            );
          },
        ),
      )
      ..addJavaScriptChannel(
        'VideoState',
        onMessageReceived: (JavaScriptMessage message) {
          print('Video state: ${message.message}');
        },
      );

    // Configure Android-specific settings
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      final AndroidWebViewController controller = _controller.platform as AndroidWebViewController;
      controller.setMediaPlaybackRequiresUserGesture(false);
    }

    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    try {
      String htmlContent = await rootBundle.loadString('assets/youtube_player.html');
      await _controller.loadHtmlString(htmlContent, baseUrl: 'https://www.youtube.com');
      
      // Add JavaScript console logging
      await _controller.runJavaScript('''
        console.log = function(message) {
          if (window.flutter_inappwebview) {
            window.flutter_inappwebview.callHandler('consoleLog', message);
          }
        };
        console.error = function(message) {
          if (window.flutter_inappwebview) {
            window.flutter_inappwebview.callHandler('consoleError', message);
          }
        };
      ''');
    } catch (e) {
      if (mounted) {
        print('Error loading player: $e'); // Debug log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading player: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _loadHtmlFromAssets(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Reset orientation when leaving the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Stream'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: WebViewWidget(
                      controller: _controller,
                    ),
                  );
                },
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
