import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/routes/app_routes.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/app_assets.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';
import 'package:skhickens_app/views/User/location_change_screen.dart';
import 'package:skhickens_app/widgets/available_list_items.dart';
import 'package:skhickens_app/widgets/category_list_items.dart';
import 'package:skhickens_app/widgets/common_space.dart';
import 'package:skhickens_app/widgets/custom_appBar/custom_appBar.dart';
import 'package:skhickens_app/widgets/custom_container.dart';
import 'package:skhickens_app/widgets/search_field.dart';
import 'package:skhickens_app/core/utils/constants/temp_language.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: PreferredSize(preferredSize: Size.fromHeight(22.h),child: customAppBar(isSearchField: true),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(left: 12),
                //   child: Text(TempLanguage.txtCategory, style: poppinsMedium(fontSize: 18),),
                // ),
                const SpacerBoxVertical(height: 20),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      SpacerBoxHorizontal(width: 10,),
                      CategoryListItems(path: AppAssets.southFood, text: TempLanguage.txtSouthIndian,),
                      CategoryListItems(path: AppAssets.chineseFood, text: TempLanguage.txtChinese,),
                      CategoryListItems(path: AppAssets.pizzaImg, text: TempLanguage.txtPizza,),
                      CategoryListItems(path: AppAssets.coffeeFood, text: TempLanguage.txtTeaBeverages,),
                      SpacerBoxHorizontal(width: 10,),

                    ],
                  ),
                ),
                const SpacerBoxVertical(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text('Available Deals', style: poppinsMedium(fontSize: 18),),
                ),
                    const SpacerBoxVertical(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int index) {
                        return  GestureDetector(
                            onTap: (){
                              Get.toNamed(AppRoutes.dealDetail);
                            },
                            child: AvailableListItems(isFeatured: index % 2 == 0 ? true : false,));
                      },
                    )
                  ],

            ),
          ],
        ),
      ),
    );
  }
}