import 'package:get/get.dart';

class FavoritesDoctorsController extends GetxController {

  RxList<Map<String, String>> favorites = <Map<String, String>>[
    
  ].obs;

  void removeFavorite(int index) {
    favorites.removeAt(index);
  }
}