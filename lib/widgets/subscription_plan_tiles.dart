import 'package:flutter/material.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/common_space.dart';

class gradientTile extends StatelessWidget {
  const gradientTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 125,
                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      gradient: LinearGradient(
                                                      colors: [Colors.red, Colors.orange],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3)
                      )
                    ]
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 50),
                                                          child: Row(
                                                            
                                                            children: [
                                                              Image.asset(AppAssets.checkMark, scale: 3,),
                                                              SpacerBoxHorizontal(width: 10),
                                                              Text(TempLanguage.txtRedeemDeals, style: metropolisBold(fontSize: 16, color: AppColors.whiteColor),)
                                                            ],
                                                          ),
                                                        ),
                                                        SpacerBoxVertical(height: 10),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 50),
                                                          child: Row(
                                                            
                                                            children: [
                                                              Image.asset(AppAssets.checkMark, scale: 3,),
                                                              SpacerBoxHorizontal(width: 10),
                                                              Text(TempLanguage.txtGetRewards, style: metropolisBold(fontSize: 16, color: AppColors.whiteColor),)
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                );
  }
}

class PlanTiles extends StatelessWidget {
  final String heading;
  final String price;
  final String desc;
  const PlanTiles({required this.heading, required this.price, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: 125,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: AppColors.borderColor),
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: Offset(0, 3)
                      )
                    ]
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(heading, style: metropolisMedium(fontSize: 26),),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Text('\$', style: metropolisRegular(fontSize: 16),),
                                        Text(price, style: metropolisExtraBold(fontSize: 40),),
                                      ],),
                                      Text(desc, style: metropolisMedium(fontSize: 18),),
                                    ],
                                  ),
                );
  }
}