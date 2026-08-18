import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/data/models/LookupModel.dart';
import '../widgets/DoctorsPage.dart';

class SpecialtyIconMapper {
  const SpecialtyIconMapper._();

  static IconData iconForValue(String value) {
    switch (value) {
      case 'CARDIOLOGY':
        return Icons.favorite_rounded;
      case 'DERMATOLOGY':
        return Icons.spa_rounded;
      case 'PEDIATRICS':
        return Icons.child_care_rounded;
      case 'ORTHOPEDICS':
      case 'Orthopedics':
        return Icons.accessibility_new_rounded;
      case 'OPHTHALMOLOGY':
      case 'OPTOMETRY':
        return Icons.visibility_rounded;
      case 'DENTISTRY':
        return Icons.medical_services_rounded;
      case 'OBSTETRICS_GYNECOLOGY':
      case 'OBSTETRICS_AND_GYNECOLOGY':
      case 'GYNECOLOGY':
        return Icons.pregnant_woman_rounded;
      case 'ENT':
      case 'OTORHINOLARYNGOLOGY':
        return Icons.hearing_rounded;
      case 'NEUROLOGY':
      case 'BRAIN_AND_NERVES':
        return Icons.psychology_rounded;
      case 'PSYCHIATRY':
        return Icons.psychology_alt_rounded;
      case 'PHYSICAL_MEDICINE_REHABILITATION':
        return Icons.accessible_forward_rounded;
      case 'UROLOGY':
        return Icons.water_drop_rounded;
      case 'ONCOLOGY':
        return Icons.biotech_rounded;
      case 'RADIOLOGY':
        return Icons.document_scanner_rounded;
      case 'GENERAL_SURGERY':
        return Icons.content_cut_rounded;
      case 'INTERNAL_MEDICINE':
        return Icons.medical_services_rounded;
      case 'FAMILY_MEDICINE':
        return Icons.family_restroom_rounded;
      default:
        return Icons.local_hospital_rounded;
    }
  }
}

class SpecialitiesSection extends StatelessWidget {
  final bool isGrid;
  final List<LookupModel> specialities;

  const SpecialitiesSection({
    super.key,
    this.isGrid = false,
    required this.specialities,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isGrid) {
          final crossAxisCount = constraints.maxWidth >= 600
              ? 4
              : constraints.maxWidth >= 430
              ? 3
              : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: specialities.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) => _SpecialtyCard(
              item: specialities[index],
              icon: SpecialtyIconMapper.iconForValue(specialities[index].value),
              isPreview: false,
            ),
          );
        }

        final cardWidth = (constraints.maxWidth * 0.30)
            .clamp(112.0, 140.0)
            .toDouble();
        final cardHeight = (cardWidth * 0.90).clamp(104.0, 124.0).toDouble();
        return SizedBox(
          height: cardHeight + 8,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 4),
            itemCount: specialities.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(
              width: cardWidth,
              child: _SpecialtyCard(
                item: specialities[index],
                icon: SpecialtyIconMapper.iconForValue(
                  specialities[index].value,
                ),
                isPreview: true,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final LookupModel item;
  final IconData icon;
  final bool isPreview;

  const _SpecialtyCard({
    required this.item,
    required this.icon,
    required this.isPreview,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(isPreview ? 18 : 16);
    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: () => Get.to(
          () => DoctorsPage(
            specialityLabel: item.labelEn,
            specializationValue: item.value,
          ),
        ),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: isPreview ? 10 : 12,
            vertical: isPreview ? 10 : 12,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff2F80ED), Color(0xff56CCF2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: const Color(0xff2F80ED).withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isPreview ? 38 : 42,
                height: isPreview ? 38 : 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isPreview ? 22 : 24,
                ),
              ),
              const SizedBox(height: 8),
              Tooltip(
                message: item.labelEn,
                child: Text(
                  item.labelEn,
                  textAlign: TextAlign.center,
                  maxLines: isPreview ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isPreview ? 11 : 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
