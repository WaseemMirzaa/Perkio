import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/business_extended_tiles.dart';
import 'package:skhickens_app/widgets/common_button.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class HomeBusinessExtended extends StatefulWidget {
  const HomeBusinessExtended({super.key});

  @override
  State<HomeBusinessExtended> createState() => _HomeBusinessExtendedState();
}

class _HomeBusinessExtendedState extends State<HomeBusinessExtended> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(22.h),child: customAppBar(isSearchField: true),),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.lblPromotedDeal, style: poppinsMedium(fontSize: 18),),
                ),
                SizedBox(height: 1.h,),
                ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index)=> const BusinessExtendedTiles()),
                SpacerBoxVertical(height: 8.h),
              ],
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end,children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CommonButton(onSwipe: (){
                Get.toNamed(AppRoutes.addDeal);
              }, text: TempLanguage.btnLblSwipeToAddDeal),
            ),
          ],)
        ],
      ),
    );
  }
}