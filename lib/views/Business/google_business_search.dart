import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/views/place_picker/key.dart';
import 'package:swipe_app/views/place_picker/dio.dart';
import 'package:swipe_app/widgets/back_button_widget.dart';
import 'package:swipe_app/widgets/common_space.dart';
import 'package:swipe_app/widgets/custom_container.dart';
import 'package:nb_utils/nb_utils.dart';

class GoogleBusinessSearch extends StatefulWidget {
  const GoogleBusinessSearch({Key? key}) : super(key: key);

  @override
  State<GoogleBusinessSearch> createState() => _GoogleBusinessSearchState();
}

class _GoogleBusinessSearchState extends State<GoogleBusinessSearch> {
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isLoading = false.obs;
  final RxList<Map<String, dynamic>> _searchResults = <Map<String, dynamic>>[].obs;

  Future<void> _searchBusinesses(String query) async {
    if (query.isEmpty) return;

    _isLoading.value = true;
    try {
      // Using the Places API to search for businesses
      final String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=$query'
          '&type=business'
          '&key=$MAP_API_KEY';

      final response = await DioHelper.get(url);

      if (response.isSuccess && response.body != null) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List;
          _searchResults.value = results.map((place) => {
            'name': place['name'],
            'address': place['formatted_address'],
            'placeId': place['place_id'],
            'rating': place['rating']?.toString() ?? 'N/A',
          }).toList().cast<Map<String, dynamic>>();
        } else {
          _searchResults.clear();
        }
      }
    } catch (e) {
      print('Error searching businesses: $e');
      toast('Error searching businesses. Please try again.');
      _searchResults.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                CustomShapeContainer(
                  height: 22.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpacerBoxVertical(height: 20),
                       BackButtonWidget(
                        padding: EdgeInsets.zero,
                      ),
                      const SpacerBoxVertical(height: 15),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for your business...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 12.sp,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onChanged: (value) {
                          if (value.length > 2) {
                            _searchBusinesses(value);
                          } else {
                            _searchResults.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (_isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Search for your business to get started'
                          : 'No results found',
                      style: poppinsRegular(fontSize: 14),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _searchResults.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  itemBuilder: (context, index) {
                    final business = _searchResults[index];
                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 8.sp),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12.sp),
                        title: Text(
                          business['name'] ?? '',
                          style: poppinsMedium(fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              business['address'] ?? '',
                              style: poppinsRegular(fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Rating: ${business['rating']}',
                              style: poppinsRegular(
                                fontSize: 12,
                                color: AppColors.yellowColor,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context, {
                            'placeId': business['placeId'],
                            'name': business['name'],
                            'address': business['address'],
                          });
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
