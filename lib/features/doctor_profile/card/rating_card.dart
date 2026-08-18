import 'package:flutter/material.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/data/models/RatingModel.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({
    super.key,
    required this.rating,
    this.onReportPressed,
    this.onDeletePressed,
    this.showReportAction = false,
    this.isReportDisabled = false,
  });

  final RatingModel rating;
  final VoidCallback? onReportPressed;
  final VoidCallback? onDeletePressed;
  final bool showReportAction;
  final bool isReportDisabled;

  @override
  Widget build(BuildContext context) {
    final hasComment = (rating.comment ?? '').trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ReviewerAvatar(
                imageUrl: rating.userAvatarUrl,
                name: rating.reviewerName,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rating.reviewerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(rating.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDeletePressed != null)
                IconButton(
                  onPressed: onDeletePressed,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: Colors.red.shade500,
                  tooltip: 'Delete review',
                  splashRadius: 20,
                )
              else if (showReportAction)
                IconButton(
                  onPressed: isReportDisabled ? null : onReportPressed,
                  icon: const Icon(Icons.flag_outlined),
                  color: isReportDisabled
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                  disabledColor: Colors.grey.shade400,
                  tooltip: isReportDisabled
                      ? 'You have already reported this review'
                      : 'Report review',
                  splashRadius: 20,
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _StarRow(score: rating.score)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${rating.score.clamp(0, 5)}.0',
                  style: const TextStyle(
                    color: Color(0xFFB77900),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (hasComment) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                rating.comment!.trim(),
                textDirection: _textDirection(rating.comment!),
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
          const SizedBox(height: 13),
          Row(
            children: [
              Icon(
                Icons.schedule_outlined,
                size: 14,
                color: Colors.grey.shade400,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _formatDate(rating.createdAt),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static TextDirection _textDirection(String value) {
    final arabic = RegExp(r'[\u0600-\u06FF]').hasMatch(value);
    return arabic ? TextDirection.rtl : TextDirection.ltr;
  }

  static String _formatDate(String raw) {
    final date = DateTime.tryParse(raw)?.toLocal();
    if (date == null) return raw.isEmpty ? 'Recently' : raw;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final meridiem = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day} ${months[date.month - 1]} ${date.year} · $hour:$minute $meridiem';
  }
}

class _ReviewerAvatar extends StatelessWidget {
  const _ReviewerAvatar({required this.imageUrl, required this.name});

  final String? imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    final initials = name
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.12),
      foregroundImage: url.isEmpty ? null : NetworkImage(url),
      onForegroundImageError: url.isEmpty ? null : (exception, stackTrace) {},
      child: url.isEmpty
          ? Text(
              initials.isEmpty ? 'P' : initials,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            )
          : const Icon(Icons.person_outline, color: AppColors.primaryBlue),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final value = score.clamp(0, 5);
    return Row(
      children: List<Widget>.generate(
        5,
        (index) => Icon(
          index < value ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFF59E0B),
          size: 21,
        ),
      ),
    );
  }
}
