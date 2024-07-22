import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';

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
        children: [
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    SpacerBoxVertical(height: 40),
                    Row(
                      children: [
                        Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 3)
                          )
                        ],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(Icons.arrow_back),
                          ),
                          
                      ],
                    ),
                    SpacerBoxVertical(height: 20),
                    Text(TempLanguage.txtScanReceipt, style: poppinsMedium(fontSize: 25),)
                  ],
                ),
              ),
            ],
          ),
          SpacerBoxVertical(height: 80),
          Image.asset(AppAssets.scanningImg, scale: 3,),
          SpacerBoxVertical(height: 80),
          Text(TempLanguage.txtScanning, style: poppinsBold(fontSize: 12),),
          SpacerBoxVertical(height: 80),
          GestureDetector(
            onTap: (){
              Get.toNamed(AppRoutes.rewardRedeemDetail);
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
                                offset: Offset(5, 0)
                              )
                            ]
                      ),
                      child: Center(
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                  colors: [Colors.red, Colors.orange],
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