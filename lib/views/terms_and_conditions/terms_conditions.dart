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

class TermsAndConditions extends StatefulWidget {
  final bool isNotButtons;

  const TermsAndConditions({super.key, this.isNotButtons = false});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  PDFViewController? _pdfController;
  bool _reachBottom = false;
  String? _pdfPath;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  // Load PDF from assets and save to temporary directory
  Future<void> _loadPdfFromAssets() async {
    try {
      // Load PDF from assets
      final data = await DefaultAssetBundle.of(context).load('assets/pdf/Perkio - Term and Conditions.pdf');
      final bytes = data.buffer.asUint8List();
      
      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/privacy_policy.pdf');
      await tempFile.writeAsBytes(bytes);
      
      setState(() {
        _pdfPath = tempFile.path;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      // Handle error (e.g., show error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(
      header: Stack(
        children: [
          CustomShapeContainer(height: 22.h),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpacerBoxVertical(height: 40),
                BackButtonWidget(padding: EdgeInsets.zero),
                Center(
                  child: Text(
                    'Terms And Conditions', // Updated title to reflect PDF content
                    style: poppinsMedium(fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 22.h),
          Expanded(
            child: _pdfPath == null
                ? const Center(child: CircularProgressIndicator()) // Show loading while PDF loads
                : PDFView(
                    filePath: _pdfPath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onViewCreated: (PDFViewController controller) {
                      _pdfController = controller;
                      _getTotalPages();
                    },
                    onPageChanged: (int? page, int? total) {
                      if (page != null && total != null) {
                        setState(() {
                          _currentPage = page;
                          _totalPages = total;
                          // Detect if user reached the last page
                          if (page >= total - 1) {
                            _reachBottom = true;
                          } else {
                            _reachBottom = false;
                          }
                        });
                      }
                    },
                    onError: (error) {
                      print('PDFView error: $error');
                      // Handle error (e.g., show error message)
                    },
                  ),
          ),
          if (_reachBottom)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Reached the end of the document',
                style: poppinsRegular(fontSize: 12.sp, color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  // Get total pages of the PDF
  Future<void> _getTotalPages() async {
    if (_pdfController != null) {
      final totalPages = await _pdfController!.getPageCount();
      setState(() {
        _totalPages = totalPages ?? 0;
      });
    }
  }
}