import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
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

import '../../widgets/custom_appBar/custom_appBar.dart';

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
      appBar: PreferredSize(preferredSize: Size.fromHeight(22.h),child: customAppBar(isSearchField: true),),

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.lblMyDeals, style: poppinsMedium(fontSize: 18),),
                ),
            
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index)=> index % 2 == 0 ?  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.homeBusinessExtended);
                      },child:  const BusinessExtendedTiles()) :  GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRoutes.rewardsBusiness);
                        },child:  const BusinessHomeListItems() ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                SpacerBoxVertical(height: 7.h),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CommonButton(onSwipe: (){
                  Get.toNamed(AppRoutes.addDeal);
                }, text: TempLanguage.btnLblSwipeToAddDeal),
              ],
            ),
          ),
        ],
      ),
    );
  }
}