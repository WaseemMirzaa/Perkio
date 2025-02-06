import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditions extends StatefulWidget {
  final bool isNotButtons;

  const TermsAndConditions({super.key, this.isNotButtons = false});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  late WebViewController _controller;
  bool _reachBottom = false;

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
                    'TERMS AND CONDITIONS',
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
            child: WebView(
              backgroundColor: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}
