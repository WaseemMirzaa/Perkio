// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:sizer/sizer.dart';
// import 'package:swipe_app/core/utils/constants/temp_language.dart';
// import 'package:swipe_app/core/utils/constants/text_styles.dart';
// import 'package:swipe_app/widgets/back_button_widget.dart';
// import 'package:swipe_app/widgets/common_space.dart';
// import 'package:swipe_app/widgets/custom_container.dart';
// import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';

// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({super.key});

//   @override
//   State<PrivacyPolicy> createState() => _PrivacyPolicyState();
// }

// class _PrivacyPolicyState extends State<PrivacyPolicy> {
//   late WebViewController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return SecondaryLayoutWidget(
//       header: Stack(
//         children: [
//           // Using Sizer for a responsive height
//           CustomShapeContainer(),
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SpacerBoxVertical(height: 40),
//                 BackButtonWidget(
//                   padding: EdgeInsets.zero,
//                 ),
//                 Center(
//                   child: Text(
//                     TempLanguage.txtPrivacyPolicy,
//                     style: poppinsMedium(fontSize: 25),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: SizedBox(
//         height: 100.h, // Ensure the WebView takes the full available height
//         child: WebView(
//           initialUrl: "https://sites.google.com/view/swipeapp/swipe",
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (controller) {
//             _controller = controller;
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
      // Load PDF from assets (update path if using assets/pdf/)
      final data = await DefaultAssetBundle.of(context).load('assets/pdf/Perkio - Privacy Policy.pdf');
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
                    TempLanguage.txtPrivacyPolicy,
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
          SizedBox(height: 22.h), // Match TermsAndConditions layout
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
                      // Show error message to user
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to load Privacy Policy PDF')),
                      );
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