import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/business_extended_tiles.dart';
import 'package:skhickens_app/widgets/business_home_list_items.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class HomeBusiness extends StatefulWidget {
  const HomeBusiness({super.key});

  @override
  State<HomeBusiness> createState() => _HomeBusinessState();
}

class _HomeBusinessState extends State<HomeBusiness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          Stack(
            children: [
              CustomShapeContainer(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SpacerBoxVertical(height: 30),
                    Row(
                      children: [
                        Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: AppColors.whiteColor),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Image.asset(AppAssets.profileImg, scale: 3,),
                          ),
                          const SpacerBoxHorizontal(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            
                            Text(TempLanguage.txtBusinessName, style: poppinsRegular(fontSize: 14),),
                            Text(TempLanguage.txtLocation, style: poppinsRegular(fontSize: 10, color: AppColors.hintText),),
                          ],),
                        ),
                        GestureDetector(
                          onTap: (){
                           Get.toNamed(AppRoutes.notifications);
                          },
                          child: Image.asset(AppAssets.notificationImg, scale: 3,))
                      ],
                    ),
                    const SpacerBoxVertical(height: 20),
                    const SearchField(),
                  ],
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 200,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.lblMyDeals, style: poppinsMedium(fontSize: 18),),
                ),
                
                Expanded(child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (context, index)=> index % 2 == 0 ?  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.homeBusinessExtended);
                      },child:  const BusinessExtendedTiles()) :  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.rewardsBusiness);
                        },child:  const BusinessHomeListItems() ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                )),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CommonButton(onSwipe: (){
                    Get.toNamed(AppRoutes.addDeal);
                  }, text: TempLanguage.btnLblSwipeToAddDeal),
                ),
                const SpacerBoxVertical(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}