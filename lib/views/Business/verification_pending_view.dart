import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:skhickens_app/core/utils/constants/constants.dart';
import 'package:skhickens_app/widgets/common_comp.dart';
import 'package:skhickens_app/widgets/primary_layout_widget/secondary_layout.dart';

class VerificationPendingView extends StatelessWidget {
  const VerificationPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SecondaryLayoutWidget(header: titleBarComp('Verification ${getStringAsync(UserKey.ISVERIFIED)}'), body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Text('Your account verification status is: ${getStringAsync(UserKey.ISVERIFIED)}')
    ],));
  }
}
