import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatefulWidget {
  final bool isNotButtons; // Optional parameter to hide buttons

  const TermsAndConditions(
      {super.key, this.isNotButtons = false}); // Default is false

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late WebViewController _controller;
  bool _reachBottom = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context, false), // Return false on back
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:
                "https://www.termsfeed.com/live/d3ffe34f-a931-4180-becf-a386d2d54ae1",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            javascriptChannels: {
              JavascriptChannel(
                name: 'ScrollDetector',
                onMessageReceived: (message) {
                  if (message.message == 'bottom') {
                    setState(() {
                      _reachBottom = true;
                    });
                  }
                },
              ),
            },
            onPageFinished: (_) {
              _injectScrollDetectionJS();
            },
          ),
          if (!widget
              .isNotButtons) // Only show buttons if isNotButtons is false
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _reachBottom
                          ? () => Navigator.pop(context, false) // Decline
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _reachBottom ? Colors.red : Colors.grey,
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _reachBottom
                          ? () => Navigator.pop(context, true) // Accept
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _reachBottom ? Colors.green : Colors.grey,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _injectScrollDetectionJS() {
    _controller.runJavascript('''

      function isScrolledToBottom() {
        return window.scrollY + window.innerHeight >= document.documentElement.scrollHeight - 10;
      }

      window.onscroll = function() {
        if (isScrolledToBottom()) {
          ScrollDetector.postMessage('bottom');
        }
      };

      if (isScrolledToBottom()) {
        ScrollDetector.postMessage('bottom');
      }
    ''');
  }
}
