import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/receipt_model.dart';
import 'package:swipe_app/models/reward_model.dart';
import 'package:swipe_app/services/reward_service.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class ScanScreen extends StatefulWidget {
  final RewardModel? rewardModel;
  final String? userId;

  const ScanScreen({super.key, this.rewardModel, this.userId});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final RewardService _rewardService = RewardService();
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();
  bool _isLoading = false; // State to manage loading
  double _progress = 0.0; // State to manage upload progress

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true; // Show the circular progress indicator
    });

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      try {
        final file = File(image.path);
        final uniqueImageId = _uuid.v4();
        final storageRef = FirebaseStorage.instance.ref().child(
            'receipts/${widget.rewardModel!.rewardId}/${widget.userId}/$uniqueImageId');

        // Upload the file
        final uploadTask = storageRef.putFile(file);

        // Show progress of the upload
        uploadTask.snapshotEvents.listen((taskSnapshot) {
          if (taskSnapshot.state == TaskState.running) {
            setState(() {
              _progress = (taskSnapshot.bytesTransferred.toDouble() /
                  taskSnapshot.totalBytes.toDouble());
            });
          }
        });

        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Get the current receipt from Firestore
        DocumentSnapshot receiptSnapshot = await FirebaseFirestore.instance
            .collection('reward')
            .doc(widget.rewardModel!.rewardId)
            .collection('receipts')
            .doc(widget.userId)
            .get();

        ReceiptModel receipt;
        if (receiptSnapshot.exists) {
          receipt = ReceiptModel.fromMap(
              receiptSnapshot.data() as Map<String, dynamic>);
          receipt.imageUrls ??= [];
          receipt.imageUrls!.add(downloadUrl);
        } else {
          receipt = ReceiptModel(
            receiptId: widget.userId,
            businessId: widget.rewardModel?.businessId,
            rewardId: widget.rewardModel?.rewardId,
            userId: widget.userId,
            imageUrls: [downloadUrl],
            timestamp: DateTime.now(),
          );
        }

        await FirebaseFirestore.instance
            .collection('reward')
            .doc(widget.rewardModel!.rewardId)
            .collection('receipts')
            .doc(widget.userId)
            .set(receipt.toMap());

        await _rewardService.addPointsToReward(
          widget.rewardModel!.rewardId!,
          widget.userId!,
          20,
        );

        Get.offAll(() => RewardRedeemDetail(
              rewardId: widget.rewardModel?.rewardId,
              businessId: widget.rewardModel?.businessId,
              userId: widget.userId,
            ));
      } catch (e) {
        print("Error uploading image: $e");
      } finally {
        setState(() {
          _isLoading = false; // Hide the circular progress indicator
          _progress = 0.0; // Reset progress
        });
      }
    } else {
      setState(() {
        _isLoading =
            false; // Hide the circular progress indicator if no image was selected
        _progress = 0.0; // Reset progress
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            Column(
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
                const SpacerBoxVertical(height: 80),
                Text(
                  _isLoading
                      ? TempLanguage.txtProcessing
                      : TempLanguage.txtScanning,
                  style: poppinsBold(fontSize: 12),
                ),
                const SpacerBoxVertical(height: 16),
                GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
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
            if (_isLoading)
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.gradientEndColor,
                        value: _progress, // Show progress as a percentage
                        strokeWidth: 5.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${(_progress * 100).toStringAsFixed(2)}%', // Display percentage
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
