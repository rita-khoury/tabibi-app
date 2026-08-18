import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/api_constants.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointment/view/appointment_view.dart';
import 'package:tabibi/features/auth/data/models/DoctorModel.dart';
import 'package:tabibi/features/doctor_profile/binding/doctor_ratings_binding.dart';
import 'package:tabibi/features/doctor_profile/controller/doctor_profile_controller.dart';
import 'package:tabibi/features/doctor_profile/view/doctor_ratings_view.dart';

class DoctorProfileView extends StatelessWidget {
  DoctorProfileView({super.key});

  final DoctorProfileController controller = Get.put(DoctorProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.primaryBlue,
          onPressed: Get.back,
        ),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
                () => IconButton(
              onPressed: controller.isFavoriteLoading.value
                  ? null
                  : controller.toggleFavorite,
              icon: controller.isFavoriteLoading.value
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Icon(
                controller.doctor.value?.isFavorite == true
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: controller.doctor.value?.isFavorite == true
                    ? Colors.red.shade400
                    : AppColors.primaryBlue,
              ),
              tooltip: 'Save doctor',
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }
        final doctor = controller.doctor.value;
        if (doctor == null) {
          return _ProfileState(
            icon: Icons.person_search_outlined,
            title: 'Doctor information is unavailable',
            actionLabel: 'Try again',
            onAction: controller.refreshDoctor,
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: controller.refreshDoctor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 118),
            children: [
              _ProfileHeader(doctor: doctor),
              const SizedBox(height: 16),
              _StatsRow(doctor: doctor),
              const SizedBox(height: 16),
              _PricingCard(doctor: doctor),
              if (doctor.languagesSpoken.isNotEmpty) ...[
                const SizedBox(height: 16),
                _LanguagesSection(languages: doctor.languagesSpoken),
              ],
              if ((doctor.bio ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.article_outlined,
                  title: 'About the doctor',
                  child: Text(
                    doctor.bio!.trim(),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _RatingsEntry(doctor: doctor),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final doctor = controller.doctor.value;
        if (doctor == null || controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return _BookingBar(
          doctor: doctor,
          onBook: () => Get.to(() => AppointmentView(doctorId: doctor.id)),
        );
      }),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.doctor});

  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConstants.getFullImageUrl(doctor.image);
    final hasSubSpecialization = (doctor.subSpecialization ?? '')
        .trim()
        .isNotEmpty;
    final license = (doctor.licenseNumber ?? '').trim();

    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 88,
              height: 88,
              child: imageUrl.isEmpty
                  ? _DoctorPhotoFallback(name: doctor.name)
                  : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _DoctorPhotoFallback(name: doctor.name),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (doctor.isApproved)
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.verified_rounded,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  doctor.specialization,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (hasSubSpecialization) ...[
                  const SizedBox(height: 3),
                  Text(
                    doctor.subSpecialization!.trim(),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
                if (license.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: AppColors.primaryBlue,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            'License: $license',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.doctor});
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            icon: Icons.work_outline_rounded,
            value: '${doctor.experienceYears}',
            label: doctor.experienceYears == 1 ? 'Year' : 'Years',
            color: AppColors.primaryBlue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricTile(
            icon: Icons.star_rounded,
            value: doctor.averageRating.toStringAsFixed(1),
            label: 'Rating',
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.doctor});
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.payments_outlined,
      title: 'Consultation fees',
      child: Row(
        children: [
          Expanded(
            child: _FeeTile(
              title: 'Initial Visit',
              subtitle: 'First consultation',
              amount: _formatFee(doctor.initialVisitFee),
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _FeeTile(
              title: 'Return Visit',
              subtitle: 'Follow-up / re-visit',
              amount: _formatFee(doctor.returnVisitFee),
              color: const Color(0xFF0F8B8D),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatFee(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null) {
      return value?.trim().isNotEmpty == true ? '${value!.trim()} Pts' : '—';
    }
    return '${parsed.toStringAsFixed(2)} Pts';
  }
}

class _FeeTile extends StatelessWidget {
  const _FeeTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
  });
  final String title;
  final String subtitle;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _LanguagesSection extends StatelessWidget {
  const _LanguagesSection({required this.languages});
  final List<String> languages;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.language_rounded,
      title: 'Languages spoken',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: languages
            .where((language) => language.trim().isNotEmpty)
            .map(
              (language) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F6FE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              language.trim(),
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

class _RatingsEntry extends StatelessWidget {
  const _RatingsEntry({required this.doctor});
  final DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: InkWell(
        onTap: () => Get.to(
              () => const DoctorRatingsView(),
          binding: DoctorRatingsBinding(),
          arguments: doctor.id,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              const Icon(Icons.star_outline_rounded, color: Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Patient ratings',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                doctor.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 7),
              const Icon(Icons.chevron_right_rounded, color: AppColors.gray),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  const _BookingBar({required this.doctor, required this.onBook});
  final DoctorModel doctor;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Consultation from',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_PricingCard._formatFee(doctor.initialVisitFee)} – ${_PricingCard._formatFee(doctor.returnVisitFee)}',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onBook,
              icon: const Icon(Icons.calendar_month_rounded, size: 19),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({this.icon, this.title, required this.child});
  final IconData? icon;
  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primaryBlue, size: 19),
                  const SizedBox(width: 8),
                ],
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
          ],
          child,
        ],
      ),
    );
  }
}

class _DoctorPhotoFallback extends StatelessWidget {
  const _DoctorPhotoFallback({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? 'D' : name.trim()[0].toUpperCase();
    return ColoredBox(
      color: AppColors.primaryBlue.withValues(alpha: 0.12),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ProfileState extends StatelessWidget {
  const _ProfileState({
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });
  final IconData icon;
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 52),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}