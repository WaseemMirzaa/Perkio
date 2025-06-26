// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:swipe_app/core/utils/constants/text_styles.dart';
// import 'package:swipe_app/widgets/back_button_widget.dart';
// import 'package:swipe_app/widgets/common_space.dart';
// import 'package:swipe_app/widgets/custom_container.dart';
// import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class TermsAndConditions extends StatefulWidget {
//   final bool isNotButtons;

//   const TermsAndConditions({super.key, this.isNotButtons = false});

//   @override
//   State<TermsAndConditions> createState() => _TermsAndConditionsState();
// }

// class _TermsAndConditionsState extends State<TermsAndConditions> {
//   late WebViewController _controller;
//   bool _reachBottom = false;

//   @override
//   Widget build(BuildContext context) {
//     return SecondaryLayoutWidget(
//       header: Stack(
//         children: [
//           CustomShapeContainer(height: 22.h),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SpacerBoxVertical(height: 40),
//                 BackButtonWidget(padding: EdgeInsets.zero),
//                 Center(
//                   child: Text(
//                     'TERMS AND CONDITIONS',
//                     style: poppinsMedium(fontSize: 25),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 22.h),
//           Expanded(
//             child: WebView(
//               initialUrl:
//                   "https://www.termsfeed.com/live/d3ffe34f-a931-4180-becf-a386d2d54ae1",
//               javascriptMode: JavascriptMode.unrestricted,
//               onWebViewCreated: (controller) {
//                 _controller = controller;
//               },
//               javascriptChannels: {
//                 JavascriptChannel(
//                   name: 'ScrollDetector',
//                   onMessageReceived: (message) {
//                     if (message.message == 'bottom') {
//                       setState(() {
//                         _reachBottom = true;
//                       });
//                     }
//                   },
//                 ),
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/utils/constants/temp_language.dart';

class TermsAndConditions extends StatefulWidget {
  final bool isNotButtons;

  const TermsAndConditions({super.key, this.isNotButtons = false});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late WebViewController _controller;
  String _htmlContent = "";


  @override
  void initState() {
    super.initState();
    _loadHtmlFromAssets();
  }
  Future<void> _loadHtmlFromAssets() async {
    try {
      String fileText = await rootBundle.loadString('assets/html_files/terms&conditions.html');
      setState(() {
        _htmlContent = fileText;
      });
      _controller.loadHtmlString(_htmlContent);
    } catch (e) {
      print("Error loading HTML file: $e");
      // Fallback to a URL if the asset fails to load
      // _controller.loadUrl("https://sites.google.com/view/swipeapp/swipe");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(
      header: Stack(
        children: [
          CustomShapeContainer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 40),
                BackButtonWidget(
                  padding: EdgeInsets.zero,
                ),
                Center(
                  child: Text(
                    TempLanguage.txtTermsConditions,
                    style: poppinsMedium(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 180.0),
        child: WebView(
          initialUrl: 'about:blank',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            if (_htmlContent.isNotEmpty) {
              _controller.loadHtmlString(_htmlContent);
            }
          },
        ),
      ),
    );
  }

}