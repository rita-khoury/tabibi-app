import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import '../../auth/data/models/RatingModel.dart';

class RatingCard extends StatelessWidget {
  final RatingModel rating;
  final VoidCallback onReportPressed;
  final VoidCallback? onDeletePressed;

  const RatingCard({
    Key? key,
    required this.rating,
    required this.onReportPressed,
    this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userJson = rating.patientProfile?['user'];
    final patientName = userJson != null
        ? "${userJson['firstName'] ?? ''} ${userJson['lastName'] ?? ''}"
        : "مريض";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    patientName.trim().isEmpty ? "مريض بالمنصة" : patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  if (onDeletePressed != null) ...[
                    InkWell(
                      onTap: onDeletePressed,
                      borderRadius: BorderRadius.circular(25),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: onReportPressed,
                    borderRadius: BorderRadius.circular(25),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.flag_outlined,
                        color: AppColors.gray,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              RatingBarIndicator(
                rating: rating.score.toDouble(),
                itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 16.0,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  rating.score.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          if (rating.comment != null && rating.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              rating.comment!,
              style: const TextStyle(
                fontSize: 13.5,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              rating.createdAt.length >= 10
                  ? rating.createdAt.substring(0, 10)
                  : rating.createdAt,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.gray.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}