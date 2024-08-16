// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:sizer/sizer.dart';
// import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
// import 'package:swipe_app/core/utils/constants/app_assets.dart';
// import 'package:swipe_app/core/utils/constants/app_const.dart';
// import 'package:swipe_app/core/utils/constants/text_styles.dart';
// import 'package:swipe_app/routes/app_routes.dart';
// import 'package:swipe_app/views/Business/subscription_plan.dart';
// import 'package:swipe_app/views/bottom_bar_view/bottom_bar_view.dart';
// import 'package:swipe_app/views/place_picker/apis.dart';
// import 'package:swipe_app/views/place_picker/place_picker.dart';
// import 'package:swipe_app/views/place_picker/suggestion.dart';
// import 'package:swipe_app/widgets/button_widget.dart';
// import 'package:swipe_app/widgets/common_space.dart';
// import 'package:swipe_app/widgets/custom_appBar/custom_appBar.dart';
// import 'package:swipe_app/widgets/custom_container.dart';
// import 'package:swipe_app/widgets/search_field.dart';
// import 'package:swipe_app/core/utils/constants/temp_language.dart';
//
// class LocationChangeScreen extends StatefulWidget {
//   LocationChangeScreen({super.key, this.isChangeLocation = false,this.currentLocation = const LatLng(38.00000000,-97.00000000)});
//   bool isChangeLocation;
//   LatLng currentLocation;
//
//   @override
//   State<LocationChangeScreen> createState() => _LocationChangeScreenState();
// }
//
// class _LocationChangeScreenState extends State<LocationChangeScreen>{
// GoogleMapController? mapController; //contrller for Google map
// CameraPosition? cameraPosition;
// // RxString location = "".obs;
// bool isGotLocation = false;
// bool isFirstTime = true;
//
// bool currLocIconPress = false;
//
// final TextEditingController _controller = TextEditingController();
//
// Future animateToPosition({double? lat, double? long}) async {
//   await mapController?.animateCamera(CameraUpdate.newLatLngZoom(
//       LatLng(
//         widget.currentLocation.latitude ?? lat!,
//         widget.currentLocation.longitude ?? long!,
//       ),
//       await mapController?.getZoomLevel() ?? 14));
// }
//
// @override
// void initState() {
//   super.initState();
//   cameraPosition = CameraPosition(
//     target: widget.currentLocation,
//     zoom: 14.0,
//   );
// }
//
// final locationProvider = Get.put(LocationController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       body: Stack(
//         children: [
//           const GoogleMap(
//             zoomControlsEnabled: false,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(37.42796133580664, -122.085749655962),
//               zoom: 14.4746,
//             ),
//           ),
//           SizedBox(height: 25.h,
//             child: customAppBarWithTextField(searchController: TextEditingController(), onChanged: (value){
//             },
//               isReadyOnly: true,
//             onTap: ()async {
//               final Suggestion? result = await showSearch(
//               context: context,
//               delegate: AddressSearch(),
//               );
//               // This will change the text displayed in the TextField
//               if (result != null && !result.placeId.isEmptyOrNull) {
//               // result.
//
//               CameraPosition newPostition;
//
//               newPostition = await Apis.getPlaceDetailFromId(
//               result.placeId ?? "",
//               );
//
//               mapController?.animateCamera(CameraUpdate.newCameraPosition(newPostition));
//
//               // setState(() {
//               _controller.text = result.description!;
//               setState(() {
//
//               });
//               // cameraPosition = newPostition;
//
//               // });
//               }
//               },
//             ),
//           ),
//
//           Center(child: Image.asset(AppAssets.locationPin, scale: 3,)),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 1.0), // Padding to ensure the Row is constrained
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ButtonWidget(onSwipe: (){
//                       widget.isChangeLocation ? Get.back() :
//                       getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? Navigator.push(context, MaterialPageRoute(builder: (context)=>  SubscriptionPlan(fromSignUp: true,))) :
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomBarView(isUser: getStringAsync(SharedPrefKey.role) == SharedPrefKey.user ? true : false,)));
//                     }, text: TempLanguage.btnLblSwipeToSelect),
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(AppAssets.currentLocationPin, scale: 3,)
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// class LocationController extends GetxController {
//   // Reactive variables
//   var location = ''.obs;
//   var isCurrentLocation = true.obs;
//
//   // Method to update location
//   void setLocation(String newLocation) {
//     location.value = newLocation;
//   }
//
//   // Method to update current location check
//   void setCurrentLocationCheck(bool isCurrent) {
//     isCurrentLocation.value = isCurrent;
//   }
// }