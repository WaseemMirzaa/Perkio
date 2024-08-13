import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/controllers/business_controller.dart';
import 'package:skhickens_app/core/utils/constants/app_const.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/modals/deal_modal.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/services/business_services.dart';
import 'package:skhickens_app/widgets/business_home_list_items.dart';
import 'package:skhickens_app/widgets/button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/widgets/primary_layout_widget/primary_layout.dart';

import '../../widgets/custom_appBar/custom_appBar.dart';

class HomeBusiness extends StatefulWidget {
  HomeBusiness({super.key});

  @override
  State<HomeBusiness> createState() => _HomeBusinessState();
}

class _HomeBusinessState extends State<HomeBusiness> {
  final businessController = Get.put(BusinessController(BusinessServices()));

  String searchQuery = '';
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PrimaryLayoutWidget(
        header: SizedBox(height: 25.h,
          child: customAppBarWithTextField(searchController: searchController, onChanged: (value){
            setState(() {
              searchQuery = value;
            });
          }),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(TempLanguage.lblMyDeals, style: poppinsMedium(fontSize: 18),),
                    Text("${getIntAsync(UserKey.BALANCE)}\$ Remaining")
                  ],
                ),
              ),
              SizedBox(height: 1.h,),
              StreamBuilder<List<DealModel>>(
                stream: businessController.getMyDeals(getStringAsync(SharedPrefKey.uid),searchQuery: searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: circularProgressBar());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No deals available'));
                  }

                  final deals = snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
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
              SpacerBoxVertical(height: 10.h),
            ],
          ),
        ),
        footer: Padding(
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
    );

  }
}