import 'package:flutter/material.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/user/reward_redeem_detail.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpacerBoxVertical(height: 40),
                    BackButtonWidget(padding: EdgeInsets.zero,),
                    const SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtScanReceipt, style: poppinsMedium(fontSize: 25),)
                  ],
                ),
              ),
            ],
          ),
          const SpacerBoxVertical(height: 80),
          Image.asset(AppAssets.scanningImg, scale: 3,),
          const SpacerBoxVertical(height: 80),
          Text(TempLanguage.txtScanning, style: poppinsBold(fontSize: 12),),
          const SpacerBoxVertical(height: 80),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const RewardRedeemDetail()));            },
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
                                offset: const Offset(5, 0)
                              )
                            ]
                      ),
                      child: Center(
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                                  gradient: const LinearGradient(
                                  colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                          ),
                          child: Image.asset(AppAssets.scannerImg, scale: 3,),
                        ),
                      ),
                    ),
          ),
          
        ],
      ),
    );
  }
}