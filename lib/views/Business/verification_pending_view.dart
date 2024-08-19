import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/constants.dart';
import 'package:swipe_app/services/user_services.dart';
import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
import 'package:swipe_app/views/place_picker/location_map/location_map.dart';
import 'package:swipe_app/widgets/activation_dialog.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:swipe_app/widgets/primary_layout_widget/secondary_layout.dart';

class VerificationPendingView extends StatelessWidget {
  VerificationPendingView({super.key});
  final userController = UserController(UserServices());
  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(header: titleBarComp('Verification ${getStringAsync(UserKey.ISVERIFIED)}',
        onBack: (){
    }), body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 2.h,),
      Text('Your account verification status is: ${getStringAsync(UserKey.ISVERIFIED)}'),
        ButtonWidget(onSwipe: ()async {
          await userController.getUser(getStringAsync(SharedPrefKey.uid));
          getStringAsync(UserKey.ISVERIFIED) == 'verified' ? Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) =>
              LocationService(child: BottomBarView(
                  isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user
                      ? true
                      : false))), (route) => false) : showActivationDialog();
        },
            text: 'Verify'
      )

    ],));
  }
}
