import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';

class ScanScreen extends StatefulWidget {
  final RewardModel? rewardModel;
  final String? userId;

  const ScanScreen({super.key, this.rewardModel, this.userId});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final DocumentScannerController _controller = DocumentScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomShapeContainer(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerBoxVertical(height: 40),
                      BackButtonWidget(padding: EdgeInsets.zero),
                      const SpacerBoxVertical(height: 20),
                      Text(
                        TempLanguage.txtScanReceipt,
                        style: poppinsMedium(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 375,
            child: DocumentScanner(
              controller: _controller,
              onSave: (Uint8List imageBytes) {
                debugPrint("image bytes: $imageBytes");
              },
            ),
          ),
          const SpacerBoxVertical(height: 80),
          Text(
            TempLanguage.txtScanning,
            style: poppinsBold(fontSize: 12),
          ),
          const SpacerBoxVertical(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RewardRedeemDetail(
                    rewardModel: widget.rewardModel,
                    userId: widget.userId,
                  ),
                ),
              );
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 6,
                    offset: const Offset(5, 0),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientStartColor,
                        AppColors.gradientEndColor,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Image.asset(
                    AppAssets.scannerImg,
                    scale: 3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
