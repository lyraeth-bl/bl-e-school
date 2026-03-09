import 'package:bl_e_school/budi_luhur/budi_luhur.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedbackAttachmentPreview extends StatelessWidget {
  final List<String> rawAttachments;
  final bool showChips;

  const FeedbackAttachmentPreview({
    super.key,
    required this.rawAttachments,
    this.showChips = false,
  });

  @override
  Widget build(BuildContext context) {
    final parsed = rawAttachments
        .expand((r) => Utils.parseAttachments(r))
        .toList();
    final normalized = parsed
        .map((p) => Utils.normalizeToFullUrl(p))
        .where((p) => p.isNotEmpty)
        .toList();

    if (normalized.isEmpty) return const SizedBox.shrink();

    if (showChips) {
      return Wrap(
        spacing: 8,
        runSpacing: 6,
        children: normalized
            .map(
              (u) => GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: CachedNetworkImage(
                      imageUrl: u,
                      placeholder: (c, s) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (c, s, e) =>
                          const Center(child: Icon(Icons.broken_image)),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                child: Chip(
                  avatar: const CircleAvatar(child: Icon(Icons.attach_file)),
                  label: Text(u.split('/').last),
                ),
              ),
            )
            .toList(),
      );
    }

    // thumbnails grid
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (c, i) {
          final url = normalized[i];
          return GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => Dialog(
                child: CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (c, s) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (c, s, e) =>
                      const Center(child: Icon(Icons.broken_image)),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (c, s) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (c, s, e) =>
                    const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: normalized.length,
      ),
    );
  }
}
