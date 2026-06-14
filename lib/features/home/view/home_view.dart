import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widgets/specialities_section.dart';
import '../widgets/doctor_card.dart';
import '../widgets/header_wave.dart';
import '../widgets/AllSpecialitiesPage.dart';
import '../../Account/view/account_screen.dart';
import '../widgets/notifications_screen.dart';
import '../widgets/ads_banner.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 290, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSectionHeader("Specialities", () => Get.to(() => const AllSpecialitiesPage())),
                const SizedBox(height: 15),
                SpecialitiesSection(),
                const SizedBox(height: 25),

                // العنوان الديناميكي: يتغير حسب حالة البحث
                Obx(() => Text(
                  controller.isSearching.value ? "Your Requested Doctor" : "Top Doctors",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 15),

                // القائمة المفلترة (تتحدث تلقائياً)
                Obx(() => ListView.builder(
                  key: ValueKey(controller.filteredDoctors.length),
                  itemCount: controller.filteredDoctors.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => DoctorCard(doc: controller.filteredDoctors[index]),
                )),
              ],
            ),
          ),
          _header(),
          _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      GestureDetector(
        onTap: onTap,
        child: const Text("See all", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
      ),
    ],
  );

  Widget _buildSearchBar() => Positioned(
    top: 220,
    left: 20,
    right: 20,
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: TextField(
        onChanged: (value) => controller.searchDoctor(value),
        decoration: const InputDecoration(
          hintText: "Search for doctor or speciality...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.blue),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        ),
      ),
    ),
  );

  Widget _header() {
    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        height: 260,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xff2F80ED), Color(0xff56CCF2)]),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 50, width: 50, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white), child: ClipOval(child: Image.asset('assets/images/logo2.png', fit: BoxFit.cover))),
                    Row(
                      children: [
                        GestureDetector(onTap: () => Get.to(() => const NotificationsScreen()), child: const Icon(Icons.notifications_none, color: Colors.white, size: 28)),
                        const SizedBox(width: 15),
                        GestureDetector(onTap: () => Get.to(() => AccountScreen()), child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
                const Expanded(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: AdsBanner())),
              ],
            ),
          ),
        ),
      ),
    );
  }
}