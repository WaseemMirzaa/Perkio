import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/views/User/scan_screen.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/detail_tile.dart';

class RewardDetail extends StatefulWidget {
  const RewardDetail({super.key});

  @override
  State<RewardDetail> createState() => _RewardDetailState();
}

class _RewardDetailState extends State<RewardDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(AppAssets.imageHeader),
              BackButtonWidget(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpacerBoxVertical(height: 20),
              const DetailTile(),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(TempLanguage.txtRewardInfo, style: poppinsMedium(fontSize: 13.sp),),
                    const SpacerBoxVertical(height: 10),
                    Text(TempLanguage.txtLoremIpsumShort, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                  ],
                ),
              ),
              const SpacerBoxVertical(height: 20),
              Center(child: Text(TempLanguage.txtPoints, style: poppinsBold(fontSize: 13.sp, color: AppColors.secondaryText),)),
              const SpacerBoxVertical(height: 10),
              Center(child: Text('800/1000', style: poppinsRegular(fontSize: 12.sp, color: AppColors.secondaryText),)),
              const SpacerBoxVertical(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: 45,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[200],
                          boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3)
                        )
                      ]
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: const LinearGradient(
                          colors: [AppColors.gradientStartColor, AppColors.gradientEndColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: -1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(TempLanguage.txtSpendMore, style: poppinsRegular(fontSize: 10.sp, color: AppColors.hintText),),
                              const SpacerBoxHorizontal(width: 20),
                              Text("\$10", style: poppinsMedium(fontSize: 10.sp),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SpacerBoxVertical(height: 40),
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanScreen()));
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
              )

            ],
          ),
        ],
      ),
    );
  }
}