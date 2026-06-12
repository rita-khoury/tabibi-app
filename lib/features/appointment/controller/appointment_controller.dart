import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentController extends GetxController {
  DateTime today = DateTime.now();

  String selectedDate = DateTime.now().day.toString();
  String selectedPeriod = 'Morning';
  String selectedType = 'Consultation';

  List<DateTime> get nextDays =>
      List.generate(5, (i) => today.add(Duration(days: i)));

  void selectDate(String date) {
    selectedDate = date;
    update();
  }

  void selectPeriod(String value) {
    selectedPeriod = value;
    update();
  }

  void selectType(String value) {
    selectedType = value;
    update();
  }
}