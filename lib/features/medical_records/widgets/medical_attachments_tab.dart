import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/auth/repository/AuthController.dart';
import 'package:tabibi/features/medical_records/controller/medical_records_controller.dart';

class MedicalAttachmentsTab extends StatelessWidget {
  final MedicalRecordController controller = Get.find();

  MedicalAttachmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final permanent = controller.profileAttachments;
      final temporary = controller.historyAttachments;
      final isEmpty = permanent.isEmpty && temporary.isEmpty;
      final currentUserId = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>().currentUser.value?.id
          : null;

      if (controller.isAttachmentsLoading.value && isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryBlue),
        );
      }

      if (isEmpty) {
        return const _AttachmentsEmptyState(
          icon: Icons.folder_open_rounded,
          message: 'No attachments or medical reports found.',
        );
      }

      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          _sectionHeader(
            icon: Icons.folder_shared_outlined,
            title: 'Permanent Attachments',
            subtitle: 'Documents saved as part of your medical records',
          ),
          const SizedBox(height: 10),
          if (permanent.isEmpty)
            const _SectionEmptyState(message: 'No permanent attachments yet.')
          else
            ...permanent.map(
              (attachment) =>
                  _attachmentCard(context, attachment, currentUserId),
            ),
          const SizedBox(height: 24),
          _sectionHeader(
            icon: Icons.history_rounded,
            title: 'Temporary Attachments',
            subtitle: 'Documents related to your recent visits',
          ),
          const SizedBox(height: 10),
          if (temporary.isEmpty)
            const _SectionEmptyState(message: 'No temporary attachments yet.')
          else
            ...temporary.map(
              (attachment) =>
                  _attachmentCard(context, attachment, currentUserId),
            ),
        ],
      );
    });
  }

  Widget _attachmentCard(
    BuildContext context,
    dynamic attachment,
    String? currentUserId,
  ) {
    final data = attachment is Map
        ? Map<String, dynamic>.from(attachment)
        : <String, dynamic>{};
    final attachmentId = int.tryParse(data['id']?.toString() ?? '') ?? 0;
    final originalName =
        data['originalName']?.toString() ??
        data['fileName']?.toString() ??
        data['title']?.toString() ??
        '';
    final fileType =
        data['fileType']?.toString() ?? data['mimeType']?.toString();

    final canDelete = _canDeleteAttachment(data, currentUserId);
    return _AttachmentCard(
      attachment: attachment,
      addedBy: _addedByText(data, currentUserId),
      canDelete: canDelete,
      isViewing:
          attachmentId != 0 &&
          controller.viewingAttachmentIds.contains(attachmentId),
      onView: attachmentId == 0
          ? null
          : () => controller.viewAttachment(
              attachmentId: attachmentId,
              originalName: originalName,
              fileType: fileType,
            ),
      onDelete: !canDelete || attachmentId == 0
          ? null
          : () => _confirmDeleteAttachment(context, attachmentId),
    );
  }

  bool _canDeleteAttachment(
    Map<String, dynamic> attachment,
    String? currentUserId,
  ) {
    final uploadedByCurrentPatient = attachment['isUploadedByCurrentPatient'];
    if (uploadedByCurrentPatient is bool) {
      return uploadedByCurrentPatient;
    }

    // Compatibility fallback for an older response while the new backend field
    // is unavailable. The current contract supplies the boolean above.
    final attachmentUserId = attachment['userId']?.toString().trim();
    final userId = currentUserId?.trim();
    return userId != null &&
        userId.isNotEmpty &&
        attachmentUserId != null &&
        attachmentUserId.isNotEmpty &&
        attachmentUserId == userId;
  }

  Future<void> _confirmDeleteAttachment(
    BuildContext context,
    int attachmentId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete attachment?'),
        content: const Text('Are you sure you want to delete this attachment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await controller.deleteAttachment(attachmentId);
    }
  }

  String _addedByText(Map<String, dynamic> attachment, String? currentUserId) {
    final uploadedByCurrentPatient = attachment['isUploadedByCurrentPatient'];
    if (uploadedByCurrentPatient == true) {
      return 'Added by you';
    }

    final uploaderRole = attachment['uploaderRole']
        ?.toString()
        .trim()
        .toUpperCase();
    final uploaderName = attachment['uploaderName']?.toString().trim() ?? '';
    if (uploadedByCurrentPatient == false &&
        uploaderRole == 'DOCTOR' &&
        uploaderName.isNotEmpty) {
      final normalizedName = uploaderName.toLowerCase();
      if (normalizedName.startsWith('dr.') ||
          normalizedName.startsWith('dr ')) {
        return 'Added by $uploaderName';
      }
      return 'Added by Dr. $uploaderName';
    }

    if (uploadedByCurrentPatient == false) {
      return 'Added by a doctor';
    }

    // Compatibility fallback only for an older response without the new fields.
    return _canDeleteAttachment(attachment, currentUserId)
        ? 'Added by you'
        : 'Added by a doctor';
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.gray),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  final dynamic attachment;
  final String addedBy;
  final bool canDelete;
  final bool isViewing;
  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const _AttachmentCard({
    required this.attachment,
    required this.addedBy,
    required this.canDelete,
    required this.isViewing,
    required this.onView,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final data = attachment is Map
        ? Map<String, dynamic>.from(attachment)
        : <String, dynamic>{};
    final id = int.tryParse(data['id']?.toString() ?? '') ?? 0;
    final fileName = _fileName(data, id);
    final type =
        data['fileType']?.toString() ?? data['mimeType']?.toString() ?? 'File';
    final size = _formatSize(data['fileSize']);
    final date = _formatDate(data['createdAt']);
    final description = data['description']?.toString().trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              _fileIcon(type, fileName),
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [type, if (size.isNotEmpty) size].join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Uploaded $date',
                    style: const TextStyle(fontSize: 12, color: AppColors.gray),
                  ),
                ],
                const SizedBox(height: 3),
                Text(
                  addedBy,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 68,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AttachmentActionButton(
                  label: 'View',
                  icon: Icons.open_in_new_rounded,
                  color: AppColors.primaryBlue,
                  isLoading: isViewing,
                  onPressed: onView,
                ),
                if (canDelete) ...[
                  const SizedBox(height: 7),
                  _AttachmentActionButton(
                    label: 'Delete',
                    icon: Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    onPressed: onDelete,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fileName(Map<String, dynamic> data, int id) {
    final name =
        data['originalName']?.toString() ??
        data['fileName']?.toString() ??
        data['title']?.toString() ??
        '';
    if (name.trim().isNotEmpty) return name.trim();
    return id == 0 ? 'Medical file' : 'Medical file #$id';
  }

  IconData _fileIcon(String type, String fileName) {
    final normalized = '$type $fileName'.toLowerCase();
    if (normalized.contains('pdf')) return Icons.picture_as_pdf_outlined;
    if (normalized.contains('image') ||
        normalized.contains('.png') ||
        normalized.contains('.jpg') ||
        normalized.contains('.jpeg')) {
      return Icons.image_outlined;
    }
    if (normalized.contains('word') || normalized.contains('.doc')) {
      return Icons.article_outlined;
    }
    return Icons.description_outlined;
  }

  String _formatSize(dynamic rawSize) {
    final bytes = rawSize is num
        ? rawSize.toDouble()
        : double.tryParse(rawSize?.toString() ?? '');
    if (bytes == null || bytes < 0) return '';
    if (bytes < 1024) return '${bytes.round()} B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(dynamic rawDate) {
    final date = DateTime.tryParse(rawDate?.toString() ?? '')?.toLocal();
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _AttachmentActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _AttachmentActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          side: BorderSide(color: color.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: isLoading
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14),
                  const SizedBox(width: 3),
                  Text(label, style: const TextStyle(fontSize: 10)),
                ],
              ),
      ),
    );
  }
}

class _SectionEmptyState extends StatelessWidget {
  final String message;

  const _SectionEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _AttachmentsEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _AttachmentsEmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 45, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
