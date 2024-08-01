import 'package:get/get.dart';
import 'package:skhickens_app/services/home_services.dart';

class HomeController extends GetxController{
  HomeServices homeService;
  HomeController(this.homeService);

  Future<bool> updateCollection(String docID, String collectionName, Map<String, dynamic> list )async{
    return await homeService.updateCollection(collectionName, docID, list);
  }

  Future<String?> uploadImageToFirebase(String image, String userId) async {
    return await homeService.uploadImageToFirebase(image, userId);
  }
}