import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/appointments/controller/appointments_controller.dart';
import 'package:tabibi/features/appointments/model/appointment_model.dart';

class RateDoctorDialog extends StatefulWidget {
  const RateDoctorDialog({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  State<RateDoctorDialog> createState() => _RateDoctorDialogState();
}

class _RateDoctorDialogState extends State<RateDoctorDialog> {
  final _commentController = TextEditingController();
  double _rating = 5;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Rate Doctor',
                      style: TextStyle(
                        color: AppColors.primaryBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isSubmitting ? null : Get.back,
                    icon: const Icon(Icons.close),
                    color: AppColors.gray,
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'How satisfied are you with your consultation?',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              _InteractiveStarBar(
                rating: _rating,
                onChanged: _isSubmitting
                    ? null
                    : (value) => setState(() => _rating = value),
              ),
              const SizedBox(height: 8),
              Text(
                '${_rating.toInt()} out of 5',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _commentController,
                enabled: !_isSubmitting,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Write your comment here (optional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E0EA)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFD7E0EA)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryBlue,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Submit rating',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final controller = Get.find<AppointmentsController>();
    var succeeded = false;
    setState(() => _isSubmitting = true);

    try {
      succeeded = await controller.rateDoctorForAppointment(
        appointmentId: widget.appointment.id,
        rating: _rating,
        comment: _commentController.text.trim(),
      );
      if (succeeded) {
        Get.back();
        Get.snackbar(
          'Thank you!',
          'Thank you for your feedback! Your review helps guide other patients and improves our services.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryBlue,
          colorText: Colors.white,
          icon: const Icon(Icons.favorite_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class _InteractiveStarBar extends StatelessWidget {
  const _InteractiveStarBar({required this.rating, required this.onChanged});

  final double rating;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        void updateFromPosition(double dx) {
          if (onChanged == null || constraints.maxWidth <= 0) return;
          final normalized = (dx / constraints.maxWidth).clamp(0.0, 1.0);
          final wholeStar = (normalized * 5).ceil().clamp(1, 5).toDouble();
          onChanged!(wholeStar);
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => updateFromPosition(details.localPosition.dx),
          onHorizontalDragStart: (details) =>
              updateFromPosition(details.localPosition.dx),
          onHorizontalDragUpdate: (details) =>
              updateFromPosition(details.localPosition.dx),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(5, (index) {
                final fill = (rating - index).clamp(0.0, 1.0);
                return _Star(fill: fill);
              }),
            ),
          ),
        );
      },
    );
  }
}

class _Star extends StatelessWidget {
  const _Star({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    if (fill >= 1) {
      return const Icon(
        Icons.star_rounded,
        size: size,
        color: Color(0xFFFFB300),
      );
    }
    if (fill <= 0) {
      return const Icon(
        Icons.star_border_rounded,
        size: size,
        color: Color(0xFFCBD5E1),
      );
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        const Icon(
          Icons.star_border_rounded,
          size: size,
          color: Color(0xFFCBD5E1),
        ),
        ClipRect(
          clipper: _FractionalStarClipper(fill),
          child: const Icon(
            Icons.star_rounded,
            size: size,
            color: Color(0xFFFFB300),
          ),
        ),
      ],
    );
  }
}

class _FractionalStarClipper extends CustomClipper<Rect> {
  const _FractionalStarClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(covariant _FractionalStarClipper oldClipper) =>
      oldClipper.fraction != fraction;
}
