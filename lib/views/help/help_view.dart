import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(
        header: Stack(
          children: [
            CustomShapeContainer(height: 22.h,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerBoxVertical(height: 40),
                  BackButtonWidget(padding: EdgeInsets.zero,),
                  Center(child: Text('Help', style: poppinsMedium(fontSize: 25),))
                ],
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            SizedBox(height: 22.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(TempLanguage.txtLoremIpsum, style: poppinsRegular(fontSize: 15),),
            ),
          ],
        ));
  }
}