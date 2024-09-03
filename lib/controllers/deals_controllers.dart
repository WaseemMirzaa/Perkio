import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swipe_app/models/deal_model.dart';
import 'package:swipe_app/services/deals_service.dart';

class DealsController extends GetxController {
  final DealsService _dealsService = DealsService();
  var promotions = <DocumentSnapshot>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  late StreamController<List<DealModel>> _dealStreamController;
  Stream<List<DealModel>> get dealStream => _dealStreamController.stream;

  @override
  void onInit() {
    super.onInit();
    _dealStreamController = StreamController<List<DealModel>>();
    fetchPromotions();
    getDeals();
  }

  @override
  void onClose() {
    _dealStreamController.close();
    super.onClose();
  }

  Future<void> fetchPromotions() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final fetchedPromotions = await _dealsService.fetchPromotions();
      promotions.value = fetchedPromotions;
    } catch (e) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDeals() async {
    try {
      final deals = await _dealsService.fetchDeals();
      _dealStreamController.add(deals);
    } catch (e) {
      _dealStreamController.addError(e);
    }
  }
}
