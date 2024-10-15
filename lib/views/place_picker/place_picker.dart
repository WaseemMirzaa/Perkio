// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/user_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/app_utils/GeoLocationHelper.dart';
import 'package:swipe_app/core/utils/constants/app_assets.dart';
import 'package:swipe_app/core/utils/constants/app_const.dart';
import 'package:swipe_app/core/utils/constants/app_statics.dart';
import 'package:swipe_app/core/utils/constants/temp_language.dart';
import 'package:swipe_app/models/user_model.dart';
import 'package:swipe_app/views/place_picker/address_model.dart';
import 'package:swipe_app/views/place_picker/apis.dart';
import 'package:swipe_app/views/place_picker/common.dart';
import 'package:swipe_app/views/place_picker/get_current_location.dart';
import 'package:swipe_app/views/place_picker/location_utils.dart';
import 'package:swipe_app/views/place_picker/suggestion.dart';
import 'package:swipe_app/widgets/button_widget.dart';
import 'package:swipe_app/widgets/common_comp.dart';

typedef AddressCallback = void Function(AddressModel val);

class PlacesPick extends StatefulWidget {
  LatLng currentLocation;
  LatLng changeCurrentLocation;
  bool isUserLocation;
  bool isChangeBusinessLocation;
  bool? isReward;
  final UserModel?
      userModel; // Make userModel optional by using a nullable type

  PlacesPick({
    super.key,
    this.isReward,
    this.isChangeBusinessLocation = false,
    this.currentLocation = const LatLng(38.00000000, -97.00000000),
    this.changeCurrentLocation = const LatLng(38.00000000, -97.00000000),
    this.isUserLocation = false,
    this.userModel, // No need for `required` as it's now optional
  });

  @override
  _PlacesPickState createState() => _PlacesPickState();
}

class _PlacesPickState extends State<PlacesPick> {
  GoogleMapController? mapController; //contrller for Google map

  CameraPosition? cameraPosition;
  // RxString location = "".obs;
  bool isGotLocation = false;
  bool isFirstTime = true;
  var controller = Get.find<UserController>();

  bool currLocIconPress = false;

  final TextEditingController _controller = TextEditingController();

  Future animateToPosition({double? lat, double? long}) async {
    await mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
          widget.currentLocation.latitude,
          widget.currentLocation.longitude,
        ),
        await mapController?.getZoomLevel() ?? 14));
  }

  Future animateToPositionforchange({double? lat, double? long}) async {
    await mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(
          widget.changeCurrentLocation.latitude,
          widget.changeCurrentLocation.longitude,
        ),
        await mapController?.getZoomLevel() ?? 14));
  }

  @override
  void initState() {
    super.initState();
    print("The passed Lat Long is: ${widget.currentLocation}");
    cameraPosition = CameraPosition(
      target: widget.currentLocation,
      zoom: 14.0,
    );
  }

  RxString location = ''.obs;
  RxBool isCurrentLocation = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CurrentLocationModel>(
        future: getAddressFromLatLng(latLon: widget.currentLocation),
        builder: (ctx, snap) {
          if (snap.hasData) {
            CurrentLocationModel currentLocationModel =
                snap.data ?? CurrentLocationModel();
            print("Current Location Model is : ${currentLocationModel.latLon}");
            AddressModel? address = currentLocationModel.address;
            print("The Address Locatiom Model is : $address");

            return Obx(
              () => Stack(children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    target: widget.currentLocation, //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  mapType: MapType.normal,
                  //map type
                  onMapCreated: (controller) async {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition?.target.latitude ??
                          widget.currentLocation.latitude,
                      cameraPosition?.target.longitude ??
                          widget.currentLocation.longitude,
                      // localeIdentifier: "en"
                    );

                    if (placemarks.isNotEmpty) {
                      address?.locality = placemarks.first.locality;

                      address?.postalCode = placemarks.first.postalCode;
                      address?.street = placemarks.first.street;
                      address?.name = placemarks.first.name;
                      address?.administrativeArea =
                          placemarks.first.administrativeArea;
                      address?.country = placemarks.first.country;
                      address?.subAdministrativeArea =
                          placemarks.first.subAdministrativeArea;
                      address?.longitude = widget.currentLocation.longitude;
                      address?.latitude = widget.currentLocation.latitude;
                      address?.completeAddress = location.value;

                      //method called when map is created
                      ///
                      // setState(() {});
                      mapController = controller;

                      location.value =
                          ("${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}");

                      if (isFirstTime) {
                        final loc = await LocationUtils.fetchLocation();
                        Position position = Position(
                            altitudeAccuracy: 0.0,
                            longitude: loc.longitude,
                            latitude: loc.latitude,
                            timestamp: DateTime.now(),
                            accuracy: 0.0,
                            altitude: 0.0,
                            heading: 0.0,
                            speed: 0.0,
                            speedAccuracy: 100,
                            headingAccuracy: 100);
                        await animateToPosition(
                            lat: position.latitude, long: position.longitude);
                        isFirstTime = false;
                      }
                    }
                  },

                  onCameraMove: (CameraPosition cameraPositiona) async {
                    cameraPosition = cameraPositiona;
                  },
                  onCameraIdle: () async {
                    //when map drag stops
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      cameraPosition?.target.latitude ??
                          widget.currentLocation.latitude,
                      cameraPosition?.target.longitude ??
                          widget.currentLocation.longitude,
                    );
                    if (placemarks.isNotEmpty) {
                      address?.locality = placemarks.first.locality;
                      address?.postalCode = placemarks.first.postalCode;
                      address?.street = placemarks.first.street;
                      address?.name = placemarks.first.name;
                      address?.administrativeArea =
                          placemarks.first.administrativeArea;
                      address?.country = placemarks.first.country;
                      address?.subAdministrativeArea =
                          placemarks.first.subAdministrativeArea;
                      address?.longitude = cameraPosition?.target.latitude;
                      address?.latitude = cameraPosition?.target.longitude;
                      location.value =
                          ("${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}");

                      address?.completeAddress = location.value;
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 34),
                  child: Center(
                    child: IgnorePointer(
                      ignoring:
                          true, // Prevents the image from intercepting touch events
                      child: Image.asset(
                        AppAssets.locationPin,
                        width: 200, // Adjust the width
                        height: 200, // Adjust the height
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ContextExtensions(context).height(),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 70,
                        child: Row(
                          children: [
                            10.width,
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  AppColors.gradientStartColor,
                                  AppColors.gradientEndColor,
                                ])),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ).cornerRadiusWithClipRRect(100.0),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              //margin: const EdgeInsets.symmetric(horizontal: 25),
                              height: 50,

                              child: TextField(
                                controller: _controller,
                                readOnly: true,
                                onTap: () async {
                                  final Suggestion? result = await showSearch(
                                    context: context,
                                    delegate: AddressSearch(),
                                  );
                                  // This will change the text displayed in the TextField
                                  if (result != null &&
                                      !result.placeId.isEmptyOrNull) {
                                    // result.

                                    CameraPosition newPostition;

                                    newPostition =
                                        await Apis.getPlaceDetailFromId(
                                      result.placeId ?? "",
                                    );

                                    mapController?.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                            newPostition));

                                    // setState(() {
                                    _controller.text = result.description!;
                                    setState(() {});
                                    // cameraPosition = newPostition;

                                    // });
                                  }
                                },
                                decoration: InputDecoration(
                                  icon: Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, bottom: 10),
                                    width: 10,
                                    height: 10,
                                    child: currLocIconPress
                                        ? const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          )
                                        : const Icon(
                                            Icons.search,
                                            color: Colors.green,
                                          ),
                                  ),
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                ),
                              ),
                            ).expand(),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, bottom: 15),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () async {
                                      await animateToPositionforchange();
                                      if (!isGotLocation) {
                                        isGotLocation = true;

                                        // final loc = await locationController.fetchLocation();
                                        final loc =
                                            await LocationUtils.fetchLocation();
                                        Position position = Position(
                                            longitude: loc.longitude,
                                            latitude: loc.latitude,
                                            timestamp: DateTime.now(),
                                            accuracy: 0.0,
                                            altitude: 0.0,
                                            heading: 0.0,
                                            speed: 0.0,
                                            speedAccuracy: 0.0,
                                            altitudeAccuracy: 100,
                                            headingAccuracy: 100);
                                        await animateToPositionforchange(
                                            lat: position.latitude,
                                            long: position.longitude);
                                        isFirstTime = false;
                                      }
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white70,
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: const Icon(
                                          size: 25,
                                          Icons.gps_fixed,
                                          // Icons.gps_not_fixed_outlined,
                                          color: Colors.black87,
                                          // color: white,
                                        ))
                                    // .cornerRadiusWithClipRRect(15),
                                    ),
                              ),
                            ),
                            10.height,
                            //for swiping to select location
                            Container(
                              padding: const EdgeInsets.all(0),
                              width: MediaQuery.of(context).size.width - 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Image.asset(
                                  AppAssets.currentLocationPin,
                                  width: 40,
                                ),
                                title: Text(
                                  location.value,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                dense: true,
                              ),
                            ),
                            15.height,
                            if (controller.loading.value)
                              circularProgressBar()
                            else
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 1.5.w),
                                child: ButtonWidget(
                                        onSwipe: () async {
                                          List<Placemark> placeMarks =
                                              await placemarkFromCoordinates(
                                            cameraPosition?.target.latitude ??
                                                widget.currentLocation.latitude,
                                            cameraPosition?.target.longitude ??
                                                widget
                                                    .currentLocation.longitude,
                                          );
                                          print("Place Marks are: $placeMarks");
                                          if (address != null &&
                                              placeMarks.isNotEmpty) {
                                            address.locality =
                                                placeMarks.first.locality ??
                                                    placeMarks.first.country;
                                            print("If Condition is True");

                                            address.postalCode =
                                                placeMarks.first.postalCode;
                                            address.street =
                                                placeMarks.first.street;
                                            address.name =
                                                placeMarks.first.name;
                                            address.administrativeArea =
                                                placeMarks
                                                    .first.administrativeArea;
                                            address.country =
                                                placeMarks.first.country;
                                            address.subAdministrativeArea =
                                                placeMarks.first
                                                    .subAdministrativeArea;
                                            address.longitude = cameraPosition
                                                    ?.target.longitude ??
                                                widget
                                                    .currentLocation.longitude;
                                            address.latitude = cameraPosition
                                                    ?.target.latitude ??
                                                widget.currentLocation.latitude;
                                            AppStatics.geoPoint = GeoPoint(
                                                cameraPosition
                                                        ?.target.latitude ??
                                                    widget.currentLocation
                                                        .latitude,
                                                cameraPosition
                                                        ?.target.longitude ??
                                                    widget.currentLocation
                                                        .longitude);
                                            location.value =
                                                ("${placeMarks.first.name}, ${placeMarks.first.locality}, ${placeMarks.first.administrativeArea}");
                                            address.completeAddress =
                                                location.value;
                                            //moving back to previous screen

                                            // Create a GeoPoint from the address coordinates
                                            GeoPoint? geoPoint = GeoPoint(
                                                address.latitude!,
                                                address
                                                    .longitude!); // Adjust based on your implementation

// Update the existing UserModel instance with new values
                                            if (widget.isUserLocation) {
                                              widget.userModel!.latLong =
                                                  geoPoint;
                                              widget.userModel!.address =
                                                  location.value;
                                            } else {
                                              // For Navigator.pop, pass back the updated address with additional info
                                              // if (widget.isReward == true) {
                                              //   print('-------IN IFFFFF');

                                              //   await setValue(
                                              //       SharedPrefKey.latitude,
                                              //       address.latitude);
                                              //   await setValue(
                                              //       SharedPrefKey.longitude,
                                              //       address.longitude);
                                              //   Get.offAll(() =>
                                              //       const LocationService(
                                              //           child: BottomBarView(
                                              //               isUser: true)));
                                              // } else {
                                              //   print('-------IN ELSEEEEEEEE');

                                              // Navigator.pop(context, address);
                                              // }

                                              if (widget
                                                  .isChangeBusinessLocation) {
                                                log('-------------------Change Business Location---------');
                                                controller.loading.value = true;

                                                // Assuming the surrounding function is async
                                                String? addressCity =
                                                    await GeoLocationHelper
                                                        .getCityFromGeoPoint(
                                                            GeoPoint(
                                                                address
                                                                    .latitude!,
                                                                address
                                                                    .longitude!)); // Fix the second argument to longitude.

                                                await controller
                                                    .updateBusinessLocation(
                                                        addressCity ??
                                                            'No new location',
                                                        addressCity ??
                                                            'No new location',
                                                        geoPoint);

                                                await setValue(
                                                    SharedPrefKey.latitude,
                                                    address.latitude);
                                                await setValue(
                                                    SharedPrefKey.longitude,
                                                    address.longitude);
                                                await setValue(
                                                    SharedPrefKey.address,
                                                    addressCity);

                                                controller.loading.value =
                                                    false;
                                              }

                                              Navigator.pop(context, address);
                                            }
                                          }
                                          print(
                                              "Full ELse Condition is Called ${address?.completeAddress}");
                                        },
                                        text: TempLanguage.btnLblSwipeToSelect)
                                    .cornerRadiusWithClipRRect(10),
                              ),
                            50.height
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            );
          } else if (snap.hasError) {
            toast(snap.error.toString());
            Navigator.pop(context);
            return Container();
          } else {
            return Center(child: circularProgressBar());
          }
        },
      ),
    );
  }
}

class AddressSearch extends SearchDelegate<Suggestion> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion("", ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Suggestion>>(
      future: Apis.fetchSuggestions(
          input: query, lang: Localizations.localeOf(context).languageCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }
        // if (snapshot.hasError) {
        //   return Center(child: Text("Error: ${snapshot.error}"));
        // }
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => ListTile(
              title: Text(snapshot.data![index].description.toString()),
              onTap: () {
                close(context, snapshot.data![index]);
              },
            ),
            itemCount: snapshot.data!.length,
          );
        }
        return const Center(child: Text("No data available."));
      },
    );
  }
}
