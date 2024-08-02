import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/business_home_list_items.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class HomeBusiness extends StatelessWidget {
  HomeBusiness({super.key});
  final businessController = Get.put(BusinessController(BusinessServices()));
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

                StreamBuilder<List<DealModel>>(
                  stream: businessController.getMyDeals(getStringAsync(SharedPrefKey.uid)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No deals available'));
                    }

                    final deals = snapshot.data!;

                    return ListView.builder(
                      itemCount: deals.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final deal = deals[index];
                        return BusinessHomeListItems(dealModel: deal,);
                      },
                    );
                  },
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   scrollDirection: Axis.vertical,
                //   physics: const NeverScrollableScrollPhysics(),
                //   itemCount: 10,
                //   itemBuilder: (context, index)=> index % 2 == 0 ?  GestureDetector(
                //       onTap: (){
                //         Get.toNamed(AppRoutes.homeBusinessExtended);
                //       },child:  const BusinessExtendedTiles()) :  GestureDetector(
                //       onTap: (){
                //         Get.toNamed(AppRoutes.rewardsBusiness);
                //         },child:  const BusinessHomeListItems() ),
                //   padding: const EdgeInsets.symmetric(vertical: 10),
                // ),
                SpacerBoxVertical(height: 10.h),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonWidget(onSwipe: (){
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