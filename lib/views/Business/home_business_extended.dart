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
import 'package:skhickens_app/widgets/business_extended_tiles.dart';
import 'package:skhickens_app/widgets/business_home_list_items.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class PromotedDealView extends StatefulWidget {
  PromotedDealView({super.key});

  @override
  State<PromotedDealView> createState() => _PromotedDealViewState();
}

class _PromotedDealViewState extends State<PromotedDealView> {
  final businessController = Get.put(BusinessController(BusinessServices()));
  String searchQuery = '';
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar:  PreferredSize(preferredSize: Size.fromHeight(22.h),child: customAppBarWithTextField(searchController: searchController, onChanged: (value){
        setState(() {
          searchQuery = value;
        });

      }),),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(TempLanguage.lblPromotedDeal, style: poppinsMedium(fontSize: 18),),
                ),
                SizedBox(height: 1.h,),
                StreamBuilder<List<DealModel>>(
                  stream: businessController.getMyPromotedDeal(getStringAsync(SharedPrefKey.uid),searchQuery: searchQuery),
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
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: deals.length,
                    itemBuilder: (context, index) {
                      final promotedDeals = deals[index];
                      return BusinessHomeListItems(dealModel: promotedDeals);
                    });
                  }
                ),
                SpacerBoxVertical(height: 8.h),
              ],
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end,children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ButtonWidget(onSwipe: (){
                Get.toNamed(AppRoutes.addDeal);
              }, text: TempLanguage.btnLblSwipeToAddDeal),
            ),
          ],)
        ],
      ),
    );
  }
}