import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/widgets/back_button_widget.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/primary_layout_widget/secondary_layout.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(
      header: titleBarComp(TempLanguage.txtNotifications),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 22.h,),
            ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index)=> const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('No Notifications found'))
                // Row(children: [
                //   CircleAvatar(radius: 25.sp,backgroundImage: const AssetImage(AppAssets.profileImg),),
                //   const SizedBox(width: 10,),
                //   Expanded(
                //     child: Column(children: [
                //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Booking Confirmed',style: poppinsBold(fontSize: 11.sp),),
                //           Text('11:23 AM',style: poppinsBold(fontSize: 9.sp,color: AppColors.hintText.withOpacity(0.6)),),
                //         ],
                //       ),
                //       Text('Your booking with BD Jones has been confirmed...',maxLines: 2,overflow: TextOverflow.ellipsis,style: poppinsRegular(fontSize: 10.sp),
                //       ),
                //     ],
                //     ),
                //   ),
                // ],
                // ),
              ),
            ),
          ],
        ),
      ));
  }
}