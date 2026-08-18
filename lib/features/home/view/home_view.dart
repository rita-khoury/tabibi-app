import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../binding/doctor_reminders_binding.dart';
import '../controller/home_controller.dart';
import '../widgets/AllSpecialitiesPage.dart';
import '../widgets/ads_banner.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_filter_sort_sheet.dart';
import '../widgets/header_wave.dart';
import '../widgets/notifications_screen.dart';
import '../widgets/specialities_section.dart';
import 'doctor_reminders_view.dart';

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
            padding: const EdgeInsets.only(
              top: 290,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSectionHeader(
                  'Specialities',
                  () => Get.to(() => const AllSpecialitiesPage()),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  if (controller.isSpecialitiesLoading.value) {
                    return const SizedBox(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final error = controller.specialitiesErrorMessage.value;
                  if (error != null) {
                    return _InlineError(
                      message: error,
                      onRetry: controller.loadSpecialities,
                    );
                  }
                  if (controller.specialities.isEmpty) {
                    return const SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('No specialities available at the moment.'),
                      ),
                    );
                  }
                  return SpecialitiesSection(
                    specialities: controller.specialities,
                  );
                }),
                const SizedBox(height: 25),
                Obx(
                  () => Text(
                    controller.isSearching.value
                        ? 'Your Requested Doctor'
                        : 'Top Doctors',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final error = controller.doctorsErrorMessage.value;
                  if (error != null) {
                    return _InlineError(
                      message: error,
                      onRetry: controller.retryDoctors,
                    );
                  }
                  if (controller.filteredDoctors.isEmpty) {
                    return const Center(child: Text('No doctors found.'));
                  }
                  return ListView.builder(
                    key: const ValueKey('doctor_list'),
                    itemCount: controller.filteredDoctors.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        DoctorCard(doc: controller.filteredDoctors[index]),
                  );
                }),
              ],
            ),
          ),
          _header(),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) => Positioned(
    top: 220,
    left: 20,
    right: 20,
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.searchDoctor,
              decoration: const InputDecoration(
                hintText: 'Search for doctor or speciality...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 17,
                  horizontal: 20,
                ),
              ),
            ),
          ),
          Obx(() {
            final canFilter = controller.isSearching.value;
            final filtersActive =
                canFilter && controller.hasActiveDoctorFilters;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: canFilter
                        ? 'Filter & Sort'
                        : 'Enter a search term to filter results',
                    onPressed: canFilter
                        ? () => _openHomeFilters(context)
                        : null,
                    icon: Icon(
                      Icons.tune_rounded,
                      color: filtersActive
                          ? const Color(0xff2F80ED)
                          : Colors.grey.shade500,
                    ),
                  ),
                  if (filtersActive)
                    const Positioned(
                      top: 9,
                      right: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xff2F80ED),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: 8, height: 8),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );

  Future<void> _openHomeFilters(BuildContext context) async {
    final selected = await showDoctorFilterSortSheet(
      context: context,
      current: controller.doctorFilters,
      availableLanguages: controller.availableDoctorLanguages,
    );
    if (selected != null) {
      await controller.applyDoctorFilters(selected);
    }
  }

  Widget _header() {
    return ClipPath(
      clipper: HeaderWaveClipper(),
      child: Container(
        height: 260,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Obx(
                      () => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.isLoggedIn.value) ...[
                            GestureDetector(
                              onTap: () =>
                                  Get.to(() => const NotificationsScreen()),
                              child: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            GestureDetector(
                              onTap: () => Get.to(
                                () => const DoctorRemindersView(),
                                binding: DoctorRemindersBinding(),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(
                                    Icons.chat_bubble_outline,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                  if (controller.referralsCount.value > 0)
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${controller.referralsCount.value}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ] else
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: controller.handleAuthAction,
                                child: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AdsBanner(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _InlineError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
