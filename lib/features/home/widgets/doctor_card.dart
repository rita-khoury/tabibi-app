import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constance/app_alerts.dart';
import '../../../core/constance/app_messages.dart';
import '../../../core/widgets/app_network_image.dart';
import '../../../features/auth/data/models/DoctorModel.dart';
import '../../../features/auth/repository/auth_repository.dart';
import '../../doctor_profile/view/doctor_profile_view.dart';

class DoctorCard extends StatefulWidget {
  final DoctorModel doc;
  final bool openWithFreshDetails;

  const DoctorCard({
    super.key,
    required this.doc,
    this.openWithFreshDetails = false,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  var _isOpeningDoctorProfile = false;

  DoctorModel get doc => widget.doc;

  Future<void> _openDoctorProfile() async {
    if (_isOpeningDoctorProfile) return;

    if (!widget.openWithFreshDetails) {
      await Get.to(() => DoctorProfileView(), arguments: doc);
      return;
    }

    setState(() => _isOpeningDoctorProfile = true);
    try {
      final freshDoctor = await _authRepository.getDoctorById(doc.id);
      if (!mounted) return;

      if (freshDoctor == null) {
        AppAlerts.showError(
          title: AppMessages.favoriteErrorTitle,
          message: 'Unable to load doctor information. Please try again later.',
        );
        return;
      }

      await Get.to(() => DoctorProfileView(), arguments: freshDoctor);
    } catch (_) {
      if (mounted) {
        AppAlerts.showError(
          title: AppMessages.favoriteErrorTitle,
          message: 'Unable to load doctor information. Please try again later.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isOpeningDoctorProfile = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: _isOpeningDoctorProfile ? null : _openDoctorProfile,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AppNetworkImage(
                  imageUrl: doc.image,
                  width: 65,
                  height: 65,
                  borderRadius: BorderRadius.circular(16),
                  fallbackIcon: Icons.medical_services_rounded,
                  fallbackColor: Colors.blue.shade50,
                ),
                const SizedBox(width: 14),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doc.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doc.specialization,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 15,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  doc.averageRating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: _isOpeningDoctorProfile
                              ? null
                              : _openDoctorProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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
