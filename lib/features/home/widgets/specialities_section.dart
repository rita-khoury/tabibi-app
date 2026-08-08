import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/data/models/LookupModel.dart';
import '../widgets/DoctorsPage.dart';
import '../../../core/services/doctor_service.dart';
import '../../../features/auth/data/models/DoctorModel.dart';

class SpecialitiesSection extends StatelessWidget {
  final bool isGrid;
  final List<LookupModel> specialities;
  final DoctorService _service = DoctorService();

  SpecialitiesSection({
    super.key,
    this.isGrid = false,
    required this.specialities,
  });

  IconData _getIconForSpeciality(String name) {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite_sharp;
      case 'dermatology':
        return Icons.face_sharp;
      case 'optometry':
        return Icons.visibility_sharp;
      case 'dentistry':
        return Icons.medical_services_sharp;
      case 'brain & nerves':
        return Icons.psychology_sharp;
      case 'orthopedics':
        return Icons.accessible_sharp;
      case 'pediatrics':
        return Icons.child_care_sharp;
      case 'ent':
        return Icons.hearing_sharp;
      case 'gynecology':
        return Icons.pregnant_woman_sharp;
      default:
        return Icons.medical_information_sharp;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget buildItem(int index) {
      final item = specialities[index];

      return InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          Get.dialog(const Center(child: CircularProgressIndicator()));
          try {
            final rawData = await _service.getAll();

            debugPrint("DEBUG: Searching for speciality: ${item.value}");

            final List<DoctorModel> doctorsList = [];
            for (var e in rawData) {
              final doc = DoctorModel.fromJson(e);

              debugPrint(
                "DEBUG: Comparing '${doc.specialization}' with '${item.value}'",
              );

              if (doc.specialization.trim().toLowerCase() ==
                  item.value.trim().toLowerCase()) {
                doctorsList.add(doc);
              }
            }

            Get.back();

            if (doctorsList.isEmpty) {
              Get.snackbar("تنبيه", "لا يوجد أطباء في هذا التخصص حالياً");
            } else {
              Get.to(
                () =>
                    DoctorsPage(speciality: item.labelEn, doctors: doctorsList),
              );
            }
          } catch (e) {
            Get.back();
            Get.snackbar("خطأ", "تعذر جلب البيانات: ${e.toString()}");
          }
        },
        child: Container(
          width: 90,
          height: 85,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff2F80ED).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForSpeciality(item.value),
                color: Colors.white,
                size: 26,
              ),
              const SizedBox(height: 6),
              Text(
                item.labelEn,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isGrid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: specialities.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (context, index) => buildItem(index),
      );
    }

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => buildItem(index),
      ),
    );
  }
}
