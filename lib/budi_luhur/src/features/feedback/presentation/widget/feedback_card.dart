import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide Feedback;

class FeedbackCard extends StatelessWidget {
  final Feedback feedback;
  final String Function(DateTime?) formatDate;

  const FeedbackCard({
    super.key,
    required this.feedback,
    required this.formatDate,
  });

  Color _priorityColor(BuildContext context, FeedbackPriority p) {
    switch (p) {
      case FeedbackPriority.high:
        return Colors.red.shade600;
      case FeedbackPriority.medium:
        return Colors.orange.shade700;
      case FeedbackPriority.low:
        return Colors.green.shade700;
    }
  }

  Color _statusColor(BuildContext context, FeedbackStatus s) {
    switch (s) {
      case FeedbackStatus.pending:
        return Colors.grey.shade700;
      case FeedbackStatus.read:
        return Colors.blue.shade600;
      case FeedbackStatus.inProgress:
        return Colors.orange.shade600;
      case FeedbackStatus.resolved:
        return Colors.green.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final raw = feedback.attachments;
    final parsed = Utils.parseAttachments(raw);
    final normalized = parsed
        .map(Utils.normalizeToFullUrl)
        .where((e) => e.isNotEmpty)
        .toList();

    return InkWell(
      onTap: () => _showDetailSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Feedback #${feedback.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text(
                    Utils.enumToLabel(feedback.type),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _priorityColor(
                      context,
                      feedback.priority,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Utils.enumToLabel(feedback.priority),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _priorityColor(context, feedback.priority),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // category + app info
            Row(
              children: [
                if (feedback.category != null &&
                    feedback.category!.isNotEmpty) ...[
                  const Icon(Icons.label_outline, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      feedback.category!,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                const Icon(Icons.smartphone, size: 16),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '${feedback.os} • v${feedback.appVersion}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                feedback.message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            // status + date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(
                      context,
                      feedback.status,
                    ).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    Utils.enumToLabel(feedback.status),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _statusColor(context, feedback.status),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (feedback.adminResponseTime != null) ...[
                  const Icon(Icons.reply, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    formatDate(feedback.adminResponseTime?.toLocal()),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ] else ...[
                  Text(
                    'No response yet',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const Spacer(),
                Text(
                  Utils.formatDateTwo(feedback.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            if (normalized.isNotEmpty) ...[
              const SizedBox(height: 12),
              FeedbackAttachmentPreview(rawAttachments: parsed),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Feedback #${feedback.id}',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              context,
                              feedback.status,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            Utils.enumToLabel(feedback.status),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: _statusColor(context, feedback.status),
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    messageContainer(context),

                    // Admin Response
                    if (feedback.adminResponse != null &&
                        feedback.adminResponse!.isNotEmpty) ...[
                      adminResponseContainer(context),
                    ],

                    SizedBox(height: 16),

                    // Details
                    detailsFeedbackContainer(context),

                    SizedBox(height: 16),

                    // Attachments
                    if (Utils.parseAttachments(
                      feedback.attachments,
                    ).isNotEmpty) ...[
                      attachmentContainer(context),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Message components
  Widget messageContainer(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslatedLabel(messageKey),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feedback.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Admin Response components
  Widget adminResponseContainer(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getTranslatedLabel(adminResponseKey),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feedback.adminResponse!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              Utils.formatDateTwo(feedback.adminResponseTime!),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Details components
  Widget detailsFeedbackContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(categoryKey),
                value: Utils.enumToLabel(feedback.category),
              ),
              const SizedBox(width: 12),
              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(typeKey),
                value: Utils.enumToLabel(feedback.type),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(osKey),
                value: feedback.os ?? "-",
              ),
              const SizedBox(width: 12),
              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(appVersionKey),
                value: "v${feedback.appVersion}",
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(createdKey),
                value: Utils.formatDay(feedback.createdAt),
              ),

              const SizedBox(width: 16),

              FeedbackCardDetailsItem(
                title: Utils.getTranslatedLabel(updatedKey),
                value: Utils.formatDay(feedback.updatedAt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Attachments components
  Widget attachmentContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Attachment', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: Utils.normalizeToFullUrl(
                Utils.parseAttachments(feedback.attachments).first,
              ),
              placeholder: (c, s) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (c, s, e) =>
                  const Center(child: Icon(Icons.broken_image)),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
