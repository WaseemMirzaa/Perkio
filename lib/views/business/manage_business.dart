import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swipe_app/controllers/my_deals_controller.dart';
import 'package:swipe_app/core/utils/app_colors/app_colors.dart';
import 'package:swipe_app/core/utils/constants/text_styles.dart';
import 'package:swipe_app/models/deal_model.dart';

class BusinessManagementScreen extends StatefulWidget {
  const BusinessManagementScreen({super.key});

  @override
  _BusinessManagementScreenState createState() =>
      _BusinessManagementScreenState();
}

// Helper function to parse the date string with a fallback for different formats
DateTime _parseDateString(String dateString) {
  try {
    // Attempt to parse the date as an ISO8601 format (yyyy-MM-dd)
    return DateTime.parse(dateString);
  } catch (e) {
    // Fallback: Handling cases where the date format is 'yyyy-M-d' (e.g., 2024-1-1)
    final parts = dateString.split('-');
    if (parts.length == 3) {
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Ensure the month and day have two digits
      final formattedMonth = month.toString().padLeft(2, '0');
      final formattedDay = day.toString().padLeft(2, '0');

      // Recreate the date string in the correct format
      final formattedDateString = '$year-$formattedMonth-$formattedDay';
      return DateTime.parse(formattedDateString); // Parse the corrected date
    }
    throw FormatException('Invalid date format: $dateString');
  }
}

class _BusinessManagementScreenState extends State<BusinessManagementScreen> {
  DateTimeRange? _selectedDateRange;
  late Future<List<DealModel>> _dealsFuture;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Filtered deals based on date range and click history
  List<DealModel> _filterDeals(List<DealModel> deals) {
    if (_selectedDateRange == null) {
      return deals
          .where((deal) =>
              deal.clickHistory != null && deal.clickHistory!.isNotEmpty)
          .toList();
    }

    return deals.where((deal) {
      if (deal.clickHistory != null && deal.clickHistory!.isNotEmpty) {
        // Filter click history based on the date range
        bool hasClickHistoryInRange = deal.clickHistory!.keys.any((dateString) {
          DateTime clickDate = _parseDateString(dateString);
          return clickDate.isAfter(_selectedDateRange!.start
                  .subtract(const Duration(days: 1))) &&
              clickDate.isBefore(
                  _selectedDateRange!.end.add(const Duration(days: 1)));
        });
        return hasClickHistoryInRange;
      }
      return false;
    }).toList();
  }

  // Calculate total clicks for the selected date range
  int _calculateTotalClicks(Map<String, dynamic> clickHistory) {
    if (clickHistory.isEmpty) {
      return 0;
    }

    // Filter click history based on the selected date range
    final filteredClicks = clickHistory.entries.where((entry) {
      DateTime clickDate = _parseDateString(entry.key);

      // Ensure that the selected date range is not null
      if (_selectedDateRange == null) {
        return false;
      }

      return clickDate.isAfter(
              _selectedDateRange!.start.subtract(const Duration(days: 1))) &&
          clickDate
              .isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();

    // Sum the clicks for the filtered dates
    return filteredClicks.fold(0, (sum, entry) => sum + (entry.value as int));
  }

  // Open date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
      initialDateRange: _selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.gradientEndColor,
              primary: Colors.white,
              surface: AppColors.gradientStartColor,
              brightness: Brightness.dark,
            ),
            dialogBackgroundColor: AppColors.gradientStartColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dealsFuture = MyDealScreenController().fetchDeals(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Management',
            style: poppinsRegular(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientStartColor,
                AppColors.gradientEndColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<DealModel>>(
          future: _dealsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching deals: ${snapshot.error}',
                    style: poppinsRegular(fontSize: 18, color: Colors.red)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.business_center_outlined,
                        size: 80, color: Colors.grey.withOpacity(0.6)),
                    const SizedBox(height: 16),
                    Text('No deals found',
                        style:
                            poppinsRegular(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              );
            } else {
              // Apply the filter for both date range and click history
              final filteredDeals = _filterDeals(snapshot.data!);

              // If a date range is selected, display it above the list
              Widget dateRangeWidget = Container();
              if (_selectedDateRange != null) {
                dateRangeWidget = Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Deals from ${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.start)} to ${DateFormat('MMM dd, yyyy').format(_selectedDateRange!.end)}',
                      style: poppinsRegular(
                        fontSize: 14,
                        color: AppColors.gradientStartColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              // If no filtered deals are found, show the empty message
              if (filteredDeals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business_center_outlined,
                          size: 80, color: Colors.grey.withOpacity(0.6)),
                      const SizedBox(height: 16),
                      Text('No deals found for the selected filter',
                          style:
                              poppinsRegular(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              }

              // Calculate the total clicks for the filtered deals
              int totalClicks = filteredDeals.fold(0, (sum, deal) {
                // Make sure clickHistory is not null and sum the values
                if (deal.clickHistory != null) {
                  return sum +
                      deal.clickHistory!.values.fold(0, (innerSum, click) {
                        return innerSum + (click as int);
                      });
                }
                return sum;
              });

              // If a date range is selected, recalculate the total clicks for the filtered list
              if (_selectedDateRange != null) {
                totalClicks = filteredDeals.fold(0, (sum, deal) {
                  return sum + _calculateTotalClicks(deal.clickHistory!);
                });
              }

              int totalCost = totalClicks * 2; // Assuming cost per click is 2

              return Column(
                children: [
                  dateRangeWidget, // Display date range filter if available
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredDeals.length,
                      itemBuilder: (context, index) {
                        final deal = filteredDeals[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Deal Image Placeholder
                                Container(
                                  width: 80,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: deal.image!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(deal.image!,
                                              fit: BoxFit.cover,
                                              width: 80,
                                              height: 120),
                                        )
                                      : const Icon(Icons.image,
                                          size: 40, color: Colors.grey),
                                ),
                                const SizedBox(width: 12),
                                // Deal Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Deal Title
                                      Text(deal.dealName!,
                                          style: poppinsRegular(
                                              fontSize: 16,
                                              color: Colors.black)),
                                      const SizedBox(height: 4),
                                      // Business Name
                                      Text(deal.companyName!,
                                          style: poppinsRegular(
                                              fontSize: 14,
                                              color: Colors.grey.shade600)),
                                      const SizedBox(height: 8),
                                      // Date Range
                                      Row(
                                        children: [
                                          Icon(Icons.date_range,
                                              color: Colors.grey.shade500,
                                              size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                              DateFormat('MMM dd, yyyy').format(
                                                  deal.createdAt!.toDate()),
                                              style: poppinsRegular(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade700)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Clicks and Cost
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                              color: AppColors.gradientEndColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              'Clicks: $totalClicks',
                                              style: poppinsRegular(
                                                  fontSize: 14,
                                                  color: AppColors
                                                      .gradientEndColor),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                              'Cost: \$${totalCost.toString()}',
                                              style: poppinsRegular(
                                                  fontSize: 14,
                                                  color:
                                                      Colors.green.shade700)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
