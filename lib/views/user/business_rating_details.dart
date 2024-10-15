import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/controllers/fetch_business_details_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/business_details_model.dart';
import 'package:swipe_app/widgets/common_comp.dart';
import 'package:flutter/services.dart';

class BusinessRatingDetailsScreen extends StatefulWidget {
  final String? businessDetailsId;
  const BusinessRatingDetailsScreen({super.key, this.businessDetailsId});

  @override
  _BusinessRatingDetailsScreenState createState() =>
      _BusinessRatingDetailsScreenState();
}

class _BusinessRatingDetailsScreenState
    extends State<BusinessRatingDetailsScreen> {
  final BusinessRatingController _controller = BusinessRatingController();
  BusniessDetailsModel? businessDetails;

  @override
  void initState() {
    super.initState();
    // Set the status bar to have light content when this screen is active
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _fetchData();
  }

  @override
  void dispose() {
    // Reset the status bar style back to default when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor:
            Color(0x40000000), // Even lighter black with 25% opacity
        statusBarIconBrightness:
            Brightness.light, // White icons for dark background
        statusBarBrightness: Brightness.dark, // Required for iOS
      ),
    );

    super.dispose();
  }

  void _fetchData() async {
    BusniessDetailsModel? fetchedDetails =
        await _controller.fetchBusinessDetails(widget.businessDetailsId!);
    setState(() {
      businessDetails = fetchedDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientStartColor,
                AppColors.gradientEndColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: Text(
              "Business Ratings",
              style: poppinsBold(fontSize: 14.sp, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // Reset system UI when navigating back
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                Get.back();
              },
            ),
          ),
        ),
      ),
      body: businessDetails == null
          ? Center(child: circularProgressBar())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: Text(
                        businessDetails?.result?.name ?? "No Name",
                        style: poppinsSemiBold(
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Rating and Reviews in a Row

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reviews...',
                          style: poppinsSemiBold(
                            color: AppColors.blackColor,
                            fontSize: 10.sp,
                          ),
                        ),

                        // Add space between the star and the rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star, // Use a star icon
                              color: Colors
                                  .yellow, // You can set the color to yellow to resemble a star rating
                              size: 16, // Adjust the size of the star
                            ),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Text(
                                businessDetails?.result?.rating != null
                                    ? '${businessDetails?.result?.rating}'
                                    : 'N/A',
                                style: poppinsSemiBold(
                                  color: AppColors.blackColor,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // List of Reviews
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: businessDetails?.result?.reviews?.length ?? 0,
                      itemBuilder: (context, index) {
                        final review = businessDetails!.result!.reviews![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Image at the top-left
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          review.profilePhotoUrl ?? ''),
                                      radius: 20,
                                    ),
                                    const SizedBox(width: 10),

                                    // Author name and rating in a vertical arrangement
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            review.authorName ?? '',
                                            style: poppinsBold(
                                              fontSize: 12.sp,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Rating: ${review.rating}',
                                            style: poppinsRegular(
                                              fontSize: 10.sp,
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Review comment in card
                                Text(
                                  review.text ?? '',
                                  style: poppinsRegular(
                                    fontSize: 10.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
