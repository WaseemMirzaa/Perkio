import 'package:flutter/material.dart';

focusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

unFocusChange(BuildContext context) {
  FocusScope.of(context).unfocus();
}