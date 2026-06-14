import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/search_controller.dart';

class SearchView extends StatelessWidget {
  // نستخدم Get.find للوصول للكنترولر الموجود في الذاكرة (بدون إعادة إنشاء)
  final DoctorSearchController controller = Get.find<DoctorSearchController>();

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Doctors")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.search(value),
              decoration: const InputDecoration(
                hintText: "Search name or speciality...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredDoctors.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(controller.filteredDoctors[i]['name']),
                subtitle: Text(controller.filteredDoctors[i]['speciality']),
              ),
            )),
          ),
        ],
      ),
    );
  }
}