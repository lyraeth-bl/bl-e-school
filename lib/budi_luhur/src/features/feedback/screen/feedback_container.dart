import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:flutter/material.dart' hide Feedback;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackContainer extends StatefulWidget {
  const FeedbackContainer({super.key});

  @override
  State<FeedbackContainer> createState() => _FeedbackContainerState();
}

class _FeedbackContainerState extends State<FeedbackContainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchUserFeedback());
  }

  void _fetchUserFeedback() async {
    final authDetails = context.read<AuthCubit>().getStudentDetails;

    context.read<GetFeedbackCubit>().fetchUserFeedback(nis: authDetails.nis);
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    final dt = d.toLocal();
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$yyyy-$mm-$dd $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetFeedbackCubit, GetFeedbackState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (userFeedbackList, lastUpdate) => context
              .read<FeedbackCubit>()
              .updateFeedbackUserData(userFeedbackList.first),
          orElse: () {},
        );
      },
      child: RefreshIndicator(
        onRefresh: () async => _fetchUserFeedback(),
        child: BlocBuilder<GetFeedbackCubit, GetFeedbackState>(
          builder: (c, s) {
            return s.maybeWhen(
              success: (userFeedbackList, lastUpdate) {
                if (userFeedbackList.isEmpty) {
                  return Center(
                    child: Text(Utils.getTranslatedLabel(noDataFoundKey)),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    FeedbackCard(
                      feedback: userFeedbackList.first,
                      formatDate: _formatDate,
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              orElse: () => Center(child: CircularProgressIndicator()),
              failure: (errorMessage) =>
                  Center(child: ErrorContainer(errorMessageCode: errorMessage)),
            );
          },
        ),
      ),
    );
  }
}

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

  String _enumToLabel(Object? e) {
    if (e == null) return '-';
    final s = e.toString().split('.').last;
    return s
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .trim()
        .replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m[0]!.toUpperCase());
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL tidak valid')));
      return;
    }
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tidak bisa membuka URL')));
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
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
            // top row: id + chips
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
                    _enumToLabel(feedback.type),
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
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _enumToLabel(feedback.priority),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _priorityColor(context, feedback.priority),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // category + app/os (compact)
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (feedback.category != null &&
                          feedback.category!.isNotEmpty) ...[
                        const Icon(Icons.label_outline, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            feedback.category!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.smartphone, size: 16),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${feedback.os} • v${feedback.appVersion}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            // status and timestamps row
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
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _enumToLabel(feedback.status),
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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ] else ...[
                  Text(
                    'No response yet',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  Utils.formatDateTwo(feedback.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            // attachments
            if (feedback.attachments != null &&
                feedback.attachments!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: feedback.attachments!.split(',').map((s) {
                  final trimmed = s.trim();
                  final filename = trimmed.split('/').last;
                  return GestureDetector(
                    onTap: () => _openUrl(context, trimmed),
                    child: Chip(
                      avatar: const CircleAvatar(
                        child: Icon(Icons.attach_file, size: 18),
                      ),
                      label: Text(
                        filename,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
                    // header row
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Feedback #${feedback.id}',
                            style: Theme.of(context).textTheme.titleMedium
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
                            _enumToLabel(feedback.status),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: _statusColor(context, feedback.status),
                                ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Align(
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
                              'Message',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              feedback.message,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (feedback.adminResponse != null &&
                        feedback.adminResponse!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Response',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onTertiaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                feedback.adminResponse!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onTertiaryContainer
                                          .withValues(alpha: 0.8),
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                Utils.formatDateTwo(
                                  feedback.adminResponseTime!,
                                ),
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onTertiaryContainer,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
                                      ),
                                      child: Text(
                                        _enumToLabel(feedback.category),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Type',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outlineVariant,
                                        ),
                                      ),
                                      child: Text(
                                        _enumToLabel(feedback.type),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.smartphone, size: 16),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            feedback.os ?? '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'App',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'v${feedback.appVersion}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      Utils.formatDay(feedback.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Updated',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      Utils.formatDay(feedback.updatedAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
