import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skhickens_app/core/utils/app_colors/app_colors.dart';
import 'package:skhickens_app/core/utils/constants/text_styles.dart';

AlertDialog imageDialog({required Function() galleryTap, required Function() cameraTap})=>AlertDialog(
  title: Text('Pick Image',style: poppinsBold(fontSize: 15),),
  content: const Text('Please choose an image source from the following'),
  actions: [
    IconButton(onPressed: cameraTap, icon: const Column(
      children: [
        Icon(Icons.camera_alt_outlined),
        Text('Camera')
      ],
    )),

    SizedBox(width: 2.w,),

    IconButton(onPressed: galleryTap ,icon: const Column(
      children: [
        Icon(Icons.image),
        Text('Gallery')
      ],
    )),
  ],
);

Widget uploadImageComp(File? link, Function() onTap)=>GestureDetector(
  onTap: onTap,
  child: Container(
    height: 12.h,
    width: 12.h,
    decoration: BoxDecoration(color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: AppColors.blackColor.withOpacity(0.16),offset: const Offset(5,10),blurRadius: 6.5),
        BoxShadow(color: AppColors.blackColor.withOpacity(0.16),offset: const Offset(0,3),blurRadius: 6.5),
      ],
      image: link == null ? null : DecorationImage(image: FileImage(link),fit: BoxFit.cover),
    ),
    child: link == null ? const Icon(Icons.camera_alt,size: 50,) : const SizedBox(),
  ),
);
