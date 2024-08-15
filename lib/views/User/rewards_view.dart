import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/User/reward_detail.dart';
import 'package:skhickens_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:skhickens_app/widgets/rewards_list_items.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';


class RewardsView extends StatelessWidget {

  const RewardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(12.h),child: customAppBar(),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(TempLanguage.txtRewards, style: poppinsMedium(fontSize: 18),),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const RewardDetail()));
              },
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index)=> const RewardsListItems(),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
